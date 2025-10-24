"""
Script d'analyse de la base DVF
--------------------------------

Ce script charge un fichier DVF zippé (format TXT), procède à un nettoyage
élémentaire des données, calcule des statistiques descriptives, entraîne
plusieurs modèles de prédiction de la valeur foncière et exporte les
résultats et graphiques dans des fichiers.  Il est écrit en français afin
de faciliter la compréhension des étudiants.

Usage :
    python analysis_dvf.py --input valeursfoncieres-2025-s1.txt.zip --output-prefix dvf2025s1

Les fichiers générés comprendront :
    - dvf2025s1_clean_sample.csv : échantillon nettoyé (50 000 lignes)
    - dvf2025s1_model_results.json : performances des modèles
    - dvf2025s1_fig_hist.png : histogramme du prix au m²
    - dvf2025s1_fig_scatter.png : graphique observé/prédit pour le meilleur modèle

Auteur : Votre groupe
Date : 2025-10
"""

import argparse
import json
import os
import zipfile

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import GradientBoostingRegressor, RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.metrics import (
    mean_absolute_percentage_error,
    mean_squared_error,
    r2_score,
)
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder


def convert_valeur_fonciere(val: str) -> float:
    """Convertit la chaîne de la colonne 'Valeur foncière' en float.

    La valeur est au format français (virgule décimale).  Les espaces sont
    supprimés et les virgules sont remplacées par des points.
    """
    if pd.isna(val):
        return np.nan
    val_str = str(val).replace(" ", "").replace(",", ".")
    try:
        return float(val_str)
    except Exception:
        return np.nan


def charger_et_nettoyer(path_zip: str, sample_size: int = 50000) -> pd.DataFrame:
    """Charge le fichier DVF zippé et renvoie un DataFrame nettoyé.

    Cette fonction ouvre l'archive ZIP, lit le fichier texte séparé par des
    barres verticales (|), filtre les ventes de maisons et d'appartements,
    convertit la valeur foncière en nombre, supprime les lignes avec des
    surfaces ou des valeurs nulles et renvoie un échantillon aléatoire.

    Args:
        path_zip: chemin vers le fichier zip DVF.
        sample_size: nombre de lignes à prélever pour l'analyse.  Si None,
            toutes les lignes nettoyées sont retournées.

    Returns:
        DataFrame avec les colonnes utiles :
        Date mutation, Valeur fonciere num, Type local, Surface reelle bati,
        Nombre pieces principales, prix_m2, Code departement.
    """
    with zipfile.ZipFile(path_zip) as zf:
        name = zf.namelist()[0]
        with zf.open(name) as f:
            df = pd.read_csv(f, sep="|", low_memory=False)
    # Filtrage
    df = df[df["Nature mutation"] == "Vente"]
    df = df[df["Type local"].isin(["Maison", "Appartement"])]
    # Conversion de la valeur foncière
    df["Valeur fonciere num"] = df["Valeur fonciere"].apply(convert_valeur_fonciere)
    # Suppression des lignes invalides
    df = df[(df["Surface reelle bati"] > 0) & (df["Valeur fonciere num"] > 0) & (df["Nombre pieces principales"] > 0)]
    # Calcul du prix au m²
    df["prix_m2"] = df["Valeur fonciere num"] / df["Surface reelle bati"]
    # Sélection des colonnes utiles
    df = df[
        [
            "Date mutation",
            "Valeur fonciere num",
            "Type local",
            "Surface reelle bati",
            "Nombre pieces principales",
            "prix_m2",
            "Code departement",
        ]
    ].copy()
    # Échantillonnage
    if sample_size is not None and len(df) > sample_size:
        df = df.sample(sample_size, random_state=42)
    return df


def entrainer_modeles(df: pd.DataFrame) -> dict:
    """Entraîne trois modèles de régression et renvoie leurs performances.

    Args:
        df: DataFrame nettoyé.

    Returns:
        Dictionnaire contenant les performances (RMSE, R², MAPE) par modèle et
        l'objet pipeline du meilleur modèle.
    """
    features = [
        "Surface reelle bati",
        "Nombre pieces principales",
        "Type local",
        "Code departement",
    ]
    target = "Valeur fonciere num"
    X = df[features]
    y = df[target]
    categorical_features = ["Type local", "Code departement"]
    numeric_features = ["Surface reelle bati", "Nombre pieces principales"]
    preprocessor = ColumnTransformer(
        [
            ("num", "passthrough", numeric_features),
            ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features),
        ]
    )
    models = {
        "Régression linéaire": LinearRegression(),
        "Forêt aléatoire": RandomForestRegressor(
            n_estimators=50, random_state=42, n_jobs=-1
        ),
        "Gradient Boosting": GradientBoostingRegressor(random_state=42),
    }
    performances = {}
    best_rmse = np.inf
    best_model_name = None
    best_pipeline = None
    for name, model in models.items():
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        pipeline = Pipeline(
            steps=[("preprocess", preprocessor), ("model", model)]
        )
        pipeline.fit(X_train, y_train)
        y_pred = pipeline.predict(X_test)
        rmse = mean_squared_error(y_test, y_pred, squared=False)
        r2 = r2_score(y_test, y_pred)
        mape = mean_absolute_percentage_error(y_test, y_pred)
        performances[name] = {
            "RMSE": rmse,
            "R2": r2,
            "MAPE": mape,
        }
        if rmse < best_rmse:
            best_rmse = rmse
            best_model_name = name
            best_pipeline = pipeline
    performances["_best_model"] = best_model_name
    return performances, best_pipeline


def tracer_histogramme(df: pd.DataFrame, output_path: str) -> None:
    """Trace un histogramme du prix au m² et l'enregistre au format PNG."""
    prix = df["prix_m2"].dropna()
    # On tronque au 95e percentile pour réduire l'influence des valeurs extrêmes
    seuil = prix.quantile(0.95)
    prix_censures = prix[prix <= seuil]
    plt.figure(figsize=(6, 4))
    plt.hist(prix_censures, bins=50)
    plt.xlabel("Prix au m² (€/m²)")
    plt.ylabel("Fréquence")
    plt.title("Distribution du prix au m² (censurée au 95ᵉ percentile)")
    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()


def tracer_scatter(prix_observe: np.ndarray, prix_pred: np.ndarray, output_path: str) -> None:
    """Trace un nuage de points prix observé vs prédit."""
    plt.figure(figsize=(6, 4))
    plt.scatter(prix_observe, prix_pred, s=5)
    plt.xlabel("Prix observé (€)")
    plt.ylabel("Prix prédit (€)")
    plt.title("Prix observé vs prédit")
    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()


def main(args: argparse.Namespace) -> None:
    # Chargement et nettoyage
    df = charger_et_nettoyer(args.input, sample_size=args.sample)
    # Export de l'échantillon nettoyé
    sample_csv = f"{args.output_prefix}_clean_sample.csv"
    df.to_csv(sample_csv, index=False)
    print(f"Fichier échantillon sauvegardé : {sample_csv} ({len(df)} lignes)")
    # Statistiques descriptives
    hist_path = f"{args.output_prefix}_fig_hist.png"
    tracer_histogramme(df, hist_path)
    print(f"Histogramme sauvegardé : {hist_path}")
    # Entraînement des modèles
    performances, best_pipeline = entrainer_modeles(df)
    results_json = f"{args.output_prefix}_model_results.json"
    with open(results_json, "w") as f:
        json.dump(performances, f, indent=4)
    print(f"Résultats sauvegardés dans {results_json}")
    # Scatter plot pour le meilleur modèle
    if best_pipeline is not None:
        # Re-diviser pour avoir un jeu de test cohérent
        features = [
            "Surface reelle bati",
            "Nombre pieces principales",
            "Type local",
            "Code departement",
        ]
        target = "Valeur fonciere num"
        X_train, X_test, y_train, y_test = train_test_split(
            df[features], df[target], test_size=0.2, random_state=42
        )
        y_pred = best_pipeline.predict(X_test)
        scatter_path = f"{args.output_prefix}_fig_scatter.png"
        tracer_scatter(y_test, y_pred, scatter_path)
        print(f"Nuage de points sauvegardé : {scatter_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Analyse de la base DVF")
    parser.add_argument(
        "--input", help="Chemin du fichier DVF zippé (valeursfoncieres-*.txt.zip)", required=True
    )
    parser.add_argument(
        "--output-prefix", help="Préfixe des fichiers de sortie", required=True
    )
    parser.add_argument(
        "--sample", type=int, default=50000, help="Taille de l'échantillon aléatoire à extraire"
    )
    args = parser.parse_args()
    main(args)
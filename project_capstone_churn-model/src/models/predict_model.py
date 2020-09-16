# Standard imports
import os
import pickle
import sys
sys.path.append('.')

# Third-party imports
import click
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score

# pylint: disable=import-error)
# Local imports
from src.data.make_dataset import load_training_data, clean_X
from src.features.build_features import featurize_X
from src.models.train_model import load_pickled_model, load_model_results
from src.localpaths import *

PICKLED_MODEL_FILENAME = load_model_results().sort_values( by='roc_auc', ascending=False ).iloc[0:1,]['model_filename'].values[0]

@click.group()
def cli():
    pass


def predict(file_name, proba=False):
    # pylint: disable=undefined-variable)
    """
    Predict 'Churn' or 'not Churn' for each row of data in file_name.
    The file must be comma delimited. Column names don't matter, but
    the order of the columns should be the same as the order of the
    original training data.
    """
    # Load data
    X = pd.read_csv( file_name )

    # Clean and featurized our data
    X = clean_X(X)
    X = featurize_X(X, predict=True)

    # Load Model
    model = load_pickled_model(PICKLED_MODEL_FILENAME)

    # Make prediction
    if proba:
        predictions = model.predict_proba(X)[:, 1]
    else:
        predictions = model.predict(X)
    

    # Print those predictions
    return predictions

@cli.command()
@click.option('--file-name', type=str, required=True)
def click_predict(file_name):
    """
    Predict 'Churn' or 'not Churn' for each row of data in file_name.
    The file must be comma delimited. Column names don't matter, but
    the order of the columns should be the same as the order of the
    original training data.
    """
    predictions = predict(file_name)
    print(predictions)

if __name__ == "__main__":
    cli()
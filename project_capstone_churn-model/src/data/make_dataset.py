# Standard imports
import os
import sys
sys.path.append('.')


# Third-party imports
import click
import pandas as pd
from sklearn.model_selection import train_test_split 

# pylint: disable=import-error)
# Local imports
from src.localpaths import * 

@click.group()
def cli():
    pass

@cli.command()
def create_train_test_split():
    # pylint: disable=undefined-variable)
    """
    Creates X and y training set files and holdout set files
    in the data/raw directory.
    """
    print("1.Loading Data")
    df = pd.read_csv(RAW_DATA_PATH)

    print("2.Creating X and y")
    X = df.drop( columns=['Churn'] )
    y = df[['Churn']]

    print("3.Creating Train Test Split")
    X_train, X_test, y_train, y_test = train_test_split( X, y, test_size=0.25, random_state=42 )

    print("4.Saving data files")
    X_train.to_csv(X_TRAIN_RAW_PATH, index=False)
    X_test.to_csv(X_TEST_RAW_PATH, index=False)
    y_train.to_csv(Y_TRAIN_RAW_PATH, index=False)
    y_test.to_csv(Y_TEST_RAW_PATH, index=False)

def clean_X(X):
    """
    Apply cleaningsteps to X.
    """
    
    # since the distribution is skewed, i choose 20 be a good 
    # value to impute TotalCharges missing value
    bad_values_idxs = X[ X['TotalCharges'] == ' '].index
    X.loc[ bad_values_idxs, 'TotalCharges'] = 20
    X['TotalCharges'] = X['TotalCharges'].astype(float)
    return X

@cli.command()
def create_clean_training_data():
    # pylint: disable=undefined-variable)
    """
    Reads in raw X and y training data, cleans it, and writes clean
    training data out to the data/interim directory.
    """
    print("loading data")
    X_train, y_train = load_training_data()

    print("cleaning data")
    X_train = clean_X(X_trian)

    print("writing data files")
    X_train.to_csv(X_TRAIN_CLEAN_PATH, index=False)
    y_train.to_csv(Y_TRAIN_CLEAN_PATH, index=False)

def load_training_data(clean=False, final=False):
    # pylint: disable=undefined-variable)
    """
    Return X_train and y_train if they exist.
    """
    if clean:
        X_train = pd.read_csv(X_TRAIN_CLEAN_PATH)
        y_train = pd.read_csv(Y_TRAIN_CLEAN_PATH)
    elif final:
        X_train = pd.read_csv(X_TRAIN_FEATURIZED_PATH)
        y_train = pd.read_csv(Y_TRAIN_FEATURIZED_PATH)
    else:
        X_train = pd.read_csv(X_TRAIN_RAW_PATH)
        y_train = pd.read_csv(Y_TRAIN_RAW_PATH)

    return X_train, y_train

def load_test_data():
    # pylint: disable=undefined-variable)
    """
    Return X_test and y_test if they exist.
    """
    X_test = pd.read_csv(X_TEST_RAW_PATH)
    y_test = pd.read_csv(Y_TEST_RAW_PATH)

    return X_test, y_test


if __name__ == "__main__":
    cli()
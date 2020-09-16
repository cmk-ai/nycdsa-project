# Standard imports
import os
import sys
import pickle
sys.path.append('.')


# Third-party imports
import click
import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from statsmodels.stats.outliers_influence import variance_inflation_factor


# pylint: disable=import-error)
# Local imports
from src.localpaths import *
from src.data.make_dataset import load_training_data 

@click.group()
def cli():
    pass

def featurize_X(X, predict=False):
    """
    Applies all featurization steps to X
    """
    X = drop_customer_id(X)
    X = transform_binary_categorical(X)
    X = one_hot_encode_categorical_features(X, predict=predict)
    X = drop_high_vif_features(X, predict=predict)

    return X

@cli.command()
def create_featurized_data():
    # pylint: disable=undefined-variable)
    """
    Creates X and y training set files ready for modeling
    saves the data to data/processed.
    """
    print('loading data')
    X_train, y_train = load_training_data(clean=True)

    print('featurizing data')
    X_train = featurize_X(X_train)
    y_train = transform_target(y_train)

    print('saving data')
    X_train.to_csv(X_TRAIN_FEATURIZED_PATH, index=False)
    y_train.to_csv(Y_TRAIN_FEATURIZED_PATH, index=False)


def drop_customer_id(X_train):
    """
    Drops the columns CustomerID from X_train, then
    return X_train
    """
    X_train = X_train.drop( columns=['customerID'] )
    return X_train
    
def transform_binary_categorical(X_train):
    """
    Transforms binary categorical features into integers 
    (zeros and ones) for modelling
    """
    X_train['gender'] = X_train['gender'].map( {'Female':1, 'Male':0} )
    #X_train['SeniorCitizen'] # no transformation needed
    X_train['Partner'] = X_train['Partner'].map( {'Yes':1, 'No':0} )
    X_train['Dependents'] = X_train['Dependents'].map( {'Yes':1, 'No':0} )
    X_train['PhoneService'] = X_train['PhoneService'].map( {'Yes':1, 'No':0} )
    X_train['PaperlessBilling'] = X_train['PaperlessBilling'].map( {'Yes':1, 'No':0} )

    return X_train

def one_hot_encode_categorical_features(X_train, save_encoder=True, predict=False):
    # pylint: disable=undefined-variable)
    """
    One-hot encodes the categorical features, adds these to the 
    training data, then drops the original columns, Returns the 
    transformed X_train data as a pandas dataframe.
    """
    ohe_filepath = os.path.join( SRC_FEATURES_DIRECTORY, 'one-hot-encoder.pkl' )
    col_to_one_hot_encode = X_train.dtypes[ X_train.dtypes == 'object' ].index
    if predict:
        with open(ohe_filepath, 'rb') as f:
            ohe = pickle.load(f)
    else:
        ohe = OneHotEncoder(drop='first', sparse=False)
        ohe.fit( X_train[col_to_one_hot_encode] )

    ohe_features = ohe.transform( X_train[col_to_one_hot_encode] )
    ohe_features_names = ohe.get_feature_names(col_to_one_hot_encode)

    ohe_df = pd.DataFrame( ohe_features, columns=ohe_features_names )
    # Unpack ohe_df as dict column name as key and column values as dict values
    # and return the appended of new dataframe
    X_train = X_train.assign(**ohe_df)
    X_train = X_train.drop(columns=col_to_one_hot_encode)

    if save_encoder and not predict:
        print('pickling one-hot encoder')
        with open( ohe_filepath, 'wb' ) as f:
            pickle.dump(ohe, f)

    return X_train

def drop_high_vif_features(X_train, predict=False):
    # pylint: disable=undefined-variable)
    """
    Drop features with a Variance Inflation Factor of greater
    than 10
    """
    finished = False
    dropped_cols_pickle_filepath = os.path.join( SRC_FEATURES_DIRECTORY, 'col-to-drop.pkl' )
    if predict:
        with open(dropped_cols_pickle_filepath, 'rb') as f:
            cols_to_drop = pickle.load(f)
        X_train = X_train.drop( columns=cols_to_drop )
    else:
        cols_to_drop = []
        
        while not finished:
            vifs = [variance_inflation_factor(X_train.values, i) for i in range(X_train.shape[1])]
            high_vifs = sorted( zip( X_train.columns, vifs ), key=lambda x: x[1], reverse=True )
            high_vif_col, high_vif_value = high_vifs[0]
            if high_vif_value >= 10:
                print(f"dropping columns {high_vif_col} with vif value of {high_vif_value:.1f}")
                X_train = X_train.drop(columns=high_vif_col)
                cols_to_drop.append( high_vif_col )
            else:
                print("finished dropping columns")
                finished = True
        with open( dropped_cols_pickle_filepath, 'wb' ) as f:
            pickle.dump(cols_to_drop, f)
    return X_train

def transform_target(y_train):
    """
    Transforms target into zeros and ones for modeling
    """
    y_train['Churn'] = y_train['Churn'].map({'Yes':1, 'No':0})
    return y_train

if __name__ == "__main__":
    cli()
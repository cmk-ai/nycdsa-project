# Standard imports
import os
import sys
import pickle
sys.path.append('.')


# Third-party imports
import matplotlib.pyplot as plt
import click
import pandas as pd
import numpy as np
from sklearn.model_selection import learning_curve


# pylint: disable=import-error)
# Local imports
from src.localpaths import *
from src.data.make_dataset import load_training_data 



def plot_learning_curve( model, X_train, y_train, zoom_out=True ):
    """
    Plots a learning curve for hte model.
    """
    train_size, train_scores, test_scores = learning_curve( estimator=model, X=X_train, y=y_train )
    train_scores = np.mean(train_scores, axis=1)
    test_scores = np.mean(test_scores, axis=1)

    plt.plot( train_size, train_scores, label='Training Accuracy' )
    plt.plot( train_size, test_scores , label='Test Accuracy')
    if zoom_out:
        plt.ylim(0, 1.05)
    plt.legend()
    plt.title(f'Learning curve of {type(model).__name__}')
    plt.show()

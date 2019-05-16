
import os

print('successful test! File location: {}'.format(os.path.abspath(__file__)))

import datajoint as dj

print(dj.__version__)

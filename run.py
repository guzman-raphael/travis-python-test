
import os

print('successful test! File location: {}'.format(os.path.abspath(__file__)))

import datajoint as dj

print(dj.__version__)

print(dj.conn())

schema = dj.schema('raphael_test')

@schema
class Test(dj.Manual):
    definition = """
    id : int
    ---
    id2 : int
    """

Test().insert([{'id' : 5, 'id2' : 7}])

res = Test().fetch()

print(res)
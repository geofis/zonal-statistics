virtualenv python_env
source python_env/bin/activate
pip install jupyter
pip install h3
pip install ee
pip install numpy
# pip install tobler
pip install git+https://github.com/pysal/tobler.git@master
pip install geopandas
pip install pandas
pip install matplotlib
pip install earthengine-api --upgrade
pip install folium
pip install mapclassify
pip install geojson
pip install h3pandas
pip install geemap
# If this error arises: ModuleNotFoundError: No module named 'StringIO'
# Solved with: https://stackoverflow.com/questions/73662037/problem-with-stringio-importing-ee-although-it-could-be-imported-alone
# Modifying the original python file at the following location solve the problem:
# /home/jose/Descargas/pythontests/python_env/lib/python3.8/site-packages/ee/main.py
# Line 10, replace 'import StringIO' by 'from io import StringIO'.
jupyter notebook
# Token: 4/1AfgeXvttmImleQXHgDnFU2TlFGkQmlQDtd2Ch6ZYVL8q0Dq5mWA1AuDRVtU

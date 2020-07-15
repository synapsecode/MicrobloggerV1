from flask import Flask
app = Flask(__name__)
from microblogger_api import routes

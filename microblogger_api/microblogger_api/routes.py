from flask import render_template, url_for, flash, redirect
from microblogger_api import app
   
@app.route("/")
def homepage():
	return "Welcome to the microblogger API"
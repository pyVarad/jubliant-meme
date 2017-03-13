#!/usr/bin/env python


from . import wapi
from flask import render_template, request
from forms.loginForm import MyForm
from flask import jsonify


@wapi.route('/')
def index():
    form = MyForm()
    return render_template('index.html', form=form)


@wapi.route('/submit', methods=('GET', 'POST'))
def submit():
    form = MyForm()
    if form.validate_on_submit():
        ## Perform database validations here ##
        # print request.form
        res = {
            'success': True
        }
        return jsonify(res)
    return render_template('submit.html', form=form)

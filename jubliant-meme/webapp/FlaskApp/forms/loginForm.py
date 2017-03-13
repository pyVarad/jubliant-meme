from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField
from wtforms.validators import DataRequired


class MyForm(FlaskForm):
    userName = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])

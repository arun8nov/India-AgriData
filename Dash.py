import pandas as pd
import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output
import plotly.express as px

# Load the data using pandas
df = pd.read_csv('ICRISAT-District Level Data.csv')

layout = html.Div(children=[
    html.Br(),
    dash_table.DataTable(data = df.to_dict('records'),
                         style_cell={'textAlign': 'left'},
                         style_header={'backgroundColor': 'rgb(230, 230, 230)',
                                       'fontWeight': 'bold'}),
    html.Br(),
    html.H2('ICRISAT District Level Data'),
    html.Br(),
    html.Div([
        html.Div([
            dcc.Dropdown(
                id='xaxis',
                options=[{'label': i, 'value': i} for i in df.columns],
                value='District'
            )
        ], style={'width': '48%', 'display': 'inline-block'}),
        html.Div([
            dcc.Dropdown(
                id='yaxis',
                options=[{'label': i, 'value': i} for i in df.columns],
                value='ICRISAT'
            )
        ], style={'width': '48%', 'float': 'right', 'display': 'inline-block'})
    ]),
    dcc.Graph(id='graph')
])

@app.callback(
    Output('graph', 'figure'),
    [Input('xaxis', 'value'),
     Input('yaxis', 'value')]
)
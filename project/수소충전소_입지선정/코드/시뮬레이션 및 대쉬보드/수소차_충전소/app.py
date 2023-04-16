###Load packages 
import pandas as pd
import numpy as np
import warnings 
import plotly.express as px
import plotly.graph_objects as go 
import pickle
import itertools
from shapely.geometry import Point

warnings.filterwarnings("ignore")



import dash
import dash_bootstrap_components as dbc
from dash import Input, Output, dcc, html
import plotly.graph_objects as go

# server = Flask(__name__)
# CORS(server)


### Data Loader 
with open(f'./data/result_data/all_data_scen_1.pickle',"rb") as f:
    all_data_scen_1 = pickle.load(f)
    
with open(f'./data/result_data/all_data_scen_2.pickle',"rb") as f:
    all_data_scen_2 = pickle.load(f)
    
with open(f'./data/result_data/all_data_scen_3.pickle',"rb") as f:
    all_data_scen_3 = pickle.load(f)

with open(f'./data/result_data/all_data_scen_4.pickle',"rb") as f:
    all_data_scen_4 = pickle.load(f)

all_wait_time_list_scen_1, to_station_time_scen_1,to_station_distance_scen_1, _, _ = all_data_scen_1
all_wait_time_list_scen_2, to_station_time_scen_2,to_station_distance_scen_2, _, _ = all_data_scen_2
all_wait_time_list_scen_3, to_station_time_scen_3,to_station_distance_scen_3, _, _ = all_data_scen_3
all_wait_time_list_scen_4, to_station_time_scen_4,to_station_distance_scen_4, _, _ = all_data_scen_4

wait_time_by_scen = [np.array(list(itertools.chain(*all_wait_time_list_scen_1))).mean(),
                     np.array(list(itertools.chain(*all_wait_time_list_scen_2))).mean(),
                     np.array(list(itertools.chain(*all_wait_time_list_scen_3))).mean(),
                     np.array(list(itertools.chain(*all_wait_time_list_scen_4))).mean()]

duration_by_scen = [np.array(list(itertools.chain(*to_station_time_scen_1))).mean(),
                     np.array(list(itertools.chain(*to_station_time_scen_2))).mean(),
                     np.array(list(itertools.chain(*to_station_time_scen_3))).mean(),
                     np.array(list(itertools.chain(*to_station_time_scen_4))).mean()]

distance_by_scen = [np.array(list(itertools.chain(*to_station_distance_scen_1))).mean(),
                    np.array(list(itertools.chain(*to_station_distance_scen_2))).mean(),
                    np.array(list(itertools.chain(*to_station_distance_scen_3))).mean(),
                    np.array(list(itertools.chain(*to_station_distance_scen_4))).mean()]

### Data Loader plus
with open(f'./data/result_data/all_data_plus_1.pickle',"rb") as f:
    all_data_scen_plus_1 = pickle.load(f)
    
with open(f'./data/result_data/all_data_plus_2.pickle',"rb") as f:
    all_data_scen_plus_2 = pickle.load(f)
    
with open(f'./data/result_data/all_data_plus_3.pickle',"rb") as f:
    all_data_scen_plus_3 = pickle.load(f)

with open(f'./data/result_data/all_data_plus_4.pickle',"rb") as f:
    all_data_scen_plus_4 = pickle.load(f)

all_wait_time_list_scen_1_plus, to_station_time_scen_1_plus, to_station_distance_scen_1_plus, _, _ = all_data_scen_plus_1
all_wait_time_list_scen_2_plus, to_station_time_scen_2_plus, to_station_distance_scen_2_plus, _, _ = all_data_scen_plus_2
all_wait_time_list_scen_3_plus, to_station_time_scen_3_plus, to_station_distance_scen_3_plus, _, _ = all_data_scen_plus_3
all_wait_time_list_scen_4_plus, to_station_time_scen_4_plus, to_station_distance_scen_4_plus, _, _ = all_data_scen_plus_4

wait_time_by_scen_plus = [np.array(list(itertools.chain(*all_wait_time_list_scen_1_plus))).mean(),
                          np.array(list(itertools.chain(*all_wait_time_list_scen_2_plus))).mean(),
                          np.array(list(itertools.chain(*all_wait_time_list_scen_3_plus))).mean(),
                          np.array(list(itertools.chain(*all_wait_time_list_scen_4_plus))).mean()]


duration_by_scen_plus = [np.array(list(itertools.chain(*to_station_time_scen_1_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_time_scen_2_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_time_scen_3_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_time_scen_4_plus))).mean()]

distance_by_scen_plus = [np.array(list(itertools.chain(*to_station_distance_scen_1_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_distance_scen_2_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_distance_scen_3_plus))).mean(),
                         np.array(list(itertools.chain(*to_station_distance_scen_4_plus))).mean()]

######### Visualization
import plotly.io as pio

pio.templates["custom_dark"] = pio.templates["plotly_dark"]
pio.templates["custom_dark"]['layout']['font']['color'] = '#c3c4c7'

wait_time = wait_time_by_scen + wait_time_by_scen_plus

wait_time = pd.DataFrame(wait_time, columns=['wait_time'])
wait_time['scen'] = ['1','1','1','1','2','2','2','2']
wait_time['index'] = range(len(wait_time))

fig_1 = px.bar(wait_time, x='index' ,y='wait_time', color='scen')

fig_1.update_layout(
    xaxis = dict(
        tickmode = 'array',
        tickvals = list(range(8)),
        ticktext = ['시나리오1', '시나리오2', '시나리오3', '시나리오4','시나리오1', '시나리오2', '시나리오3', '시나리오4'],
        title=''),
    yaxis = dict(
        tickmode = 'array',
        tickvals = [i for i in range(0, 56, 5)],
        ticktext = [f'{i}분' for i in range(0, 56, 5)],
        title="시나리오 별 평균 이동시간"),
    margin={"l":0,"r":20,"b":0,"t":0,"pad":0},
    template="plotly_white",
    showlegend=False)

###
fig_2 = px.bar(x=[1,2,3,4] ,y=duration_by_scen)

fig_2.update_layout(
    xaxis = dict(
        tickmode = 'array',
        tickvals = [1,2,3,4],
        ticktext = ['시나리오 1', '시나리오 2', '시나리오 3', '시나리오 4'],
        title=''),
    yaxis = dict(
        tickmode = 'array',
        tickvals = [i for i in range(0, 11)],
        ticktext = [f'{i}분' for i in range(0, 11)],
        title=""),
    margin={"l":0,"r":20,"b":0,"t":0,"pad":0},
    template="simple_white")
###
fig_3 = px.bar(x=[1,2,3,4] ,y=list(np.array(distance_by_scen)/1000))

fig_3.update_layout(
    xaxis = dict(
        tickmode = 'array',
        tickvals = [1,2,3,4],
        ticktext = ['시나리오 1', '시나리오 2', '시나리오 3', '시나리오 4'],
        title=''),
    yaxis = dict(
        tickmode = 'array',
        tickvals = [i for i in range(0, 10)],
        ticktext = [f'{i}km' for i in range(0, 10)],
        title=""),
    margin={"l":0,"r":20,"b":0,"t":0,"pad":0},
    template="simple_white")


# https://assets.codepen.io/8349312/custom-styles.css
# external_stylesheets = ['https://assets.codepen.io/8349312/custom-styles.css']

app = dash.Dash(__name__,  #server=server,
                meta_tags=[{"name": "viewport", "content": "width=device-width, initial-scale=1"}])

def build_banner():
    return html.Div(
        id="banner",
        className="banner",
        children=[
            html.Div(
                id="banner-text",
                children=[
                    html.B(html.H1("RESULT REPORT")),
                ],
            )
        ])

def build_tabs():
    return html.Div(
        id="tabs",
        className="tabs",
        children=[
            dcc.Tabs(
                id="app-tabs",
                value="tab1",
                className="custom-tabs",
                children=[
                    dcc.Tab(
                        id="Level-of-Service",#"Specs-tab",
                        label="",
                        value="tab1",
                        className="custom-tab",
                        selected_className="custom-tab--selected",
                    )
                ],
            )
        ],
    )

COLORS = {
    "text":"black"
}


build_tab_1 = [
        html.Div(
            children=[
                 #page1
                 html.H4(html.B("1. 시나리오별 평균 충전소 대기 시간"), style={"color": COLORS["text"]}),
                 html.Br(),
                 dbc.Row([dbc.Col([html.H4(html.B("(1) 추가 충전소 1곳당 기기 1대"), style={"color": COLORS["text"]})],style={'width': '50%', 'display': 'inline-block'}),
                          dbc.Col([html.H4(html.B("(2) 추가 충전소 1곳당 기기 2대"), style={"color": COLORS["text"]})],style={'width': '50%', 'display': 'inline-block'})]),
                 dcc.Graph(figure=fig_1),
                 html.Br(),
                 html.H4(html.B("2. 시나리오별 평균 이동시간"), style={"color": COLORS["text"]}),
                 html.Br(),
                 dcc.Graph(figure=fig_2),
                 html.Br(),
                 html.H4(html.B("3. 시나리오별 평균 이동거리"), style={"color": COLORS["text"]}),
                 html.Br(),
                 dcc.Graph(figure=fig_3),
                 html.Br()])
    ]

app.layout = html.Div([
    html.Div(
    id="big-app-container",
    children=[
        build_banner(),
        html.Div(
            id="app-container",
            children=[
                build_tabs(),
                # Main app
                html.Div(id="app-content"),
            ],
        ),
    ],
)])


@app.callback(
    [Output("app-content", "children")],
    [Input("app-tabs", "value")]
)
def render_tab_content(tab_switch):
    if tab_switch == "tab1":
        return build_tab_1

if __name__ == "__main__":
    app.run_server(host='0.0.0.0', port=8000, debug=False)
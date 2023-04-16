###import packages 
import numpy as np
import pandas as pd 
import copy
import warnings 
from osrm_api import *

warnings.filterwarnings("ignore")
#####################################################################################################################
def main_dispatch_order(charging_car_data, station_data, time):
    charging_car_iloc = []
    station_iloc = []
    
    # iloc값을 찾기 위해 index를 reset 시킴
    charging_car_data = charging_car_data.reset_index(drop=True) 

    ###
    # d_x, d_y (end_x, end_y) 
    station_data["d_x"] = [i.x for i in station_data.geometry]
    station_data["d_y"] = [i.y for i in station_data.geometry]

    for row in charging_car_data.itertuples():
        ### 차량 정보 채우기
        # 차량 위치
        station_data["o_x"] = row.geometry.x
        station_data["o_y"] = row.geometry.y
        
        # 이동시간
        all_steps = [get_res([i[0],i[1],i[2],i[3]]) for i in station_data[['o_x','o_y','d_x','d_y']].values]
        all_durations = [get_duration(i)/60 for i in all_steps]
        
        station_data["duration"] = all_durations
        
        station_data_copy = copy.deepcopy(station_data)

        station_data_copy['arrival_time'] = station_data_copy['duration'] + time
        station_data_copy['arrival_time'] = station_data_copy['arrival_time'].astype('int')
        
        try:
            check_duration = station_data_copy.loc[station_data_copy['station_id'] == 'station_0']['arrival_time'][0]
        
            if (check_duration >= 720) & (check_duration <= 780):
                station_data_copy = station_data_copy.loc[station_data_copy['station_id'] != 'station_0']
        except:
            pass
        
        
        # 영업 종료 15분 안에 도착 할수 없는 충전소 제외
        station_data_copy = station_data_copy.loc[[i[1]['close_hour'] >= (i[1]['arrival_time']+15) for i in station_data_copy.iterrows()]]
        
        # 이용시간이 얼마 안 걸리는 충전소 index 출력
        station_index = station_data_copy.duration.idxmin()
        station_id = station_data_copy['station_id'][station_index]
        # 최종 결과물 출력
        charging_car_iloc.append(row.Index)
        station_iloc.append(station_id)
        
    return charging_car_iloc, station_iloc
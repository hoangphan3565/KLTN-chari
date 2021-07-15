
import { Injectable } from '@angular/core';
import Cookies from 'js-cookie';
import axios from "axios";

const url = {
    // baseUrl: "http://172.20.10.2:8080/api",
    baseUrl: "http://192.168.1.202:8080/api",
    projects: '/projects',
    posts:'/posts',
    cities: '/cities',
    supportedPeoples: '/supported_peoples',
    supportedPeopleRecommends: '/supported_people_recommends',
    projectTypes: '/project_types',
    feedbacks: '/feedbacks',
    login: '/login',
    register: '/register',
};

const instance = axios.create({
    baseURL: url.baseUrl,
    headers: {"Content-Type":"application/json","Accept": "application/json",},
});

instance.interceptors.request.use(request=>{
    const loginInfoStr = Cookies.get("loginInfo");
    if(loginInfoStr){
        const loginInfo = JSON.parse(loginInfoStr);
        request.headers.Authorization = `Bearer ${loginInfo.token}`
    }
    return request;
});

instance.interceptors.response.use(response=>{
    return response;
    },(error)=>{
        if(error.response.status === 401){
            window.location.href = "/#/login";
        }
    }
);


@Injectable({providedIn: 'root'})
export class Api {  
    constructor() { };
    static url = url;    
    static axios = instance;
    static get = instance.get;
    static post = instance.post;
    static put = instance.put;
    static delete = instance.delete;
}
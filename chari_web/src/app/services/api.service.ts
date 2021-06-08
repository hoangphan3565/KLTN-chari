
// import Cookies from 'js-cookie';
import { HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

const httpOptions = {
    headers: new HttpHeaders({'Content-Type': 'application/json'})
};

@Injectable({providedIn: 'root'})
export class Api {  
    constructor() { };

    static baseUrl ='http://192.168.1.18:8080/api';    
    static projects = '/projects';
    static push_notifications = '/push_notifications';
    static projectTypes = '/project_types';
    static donators = '/donators'
    static donate_details = '/donate_details'
    static collaborators = '/collaborators'
    static supportedPeoples = '/supported_peoples';
    static feedbacks = '/feedbacks';
    static users = '/users';
}
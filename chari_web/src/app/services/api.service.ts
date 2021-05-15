
// import Cookies from 'js-cookie';
import { HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

const httpOptions = {
    headers: new HttpHeaders({'Content-Type': 'application/json'})
};

@Injectable({providedIn: 'root'})
export class Api {  
    constructor() { };

    // static baseUrl ='http://192.168.137.45:8080/api';
    // static baseUrl ='http://192.168.1.114:8080/api';
    static baseUrl ='http://192.168.43.202:8080/api';
    
    static projects = '/projects';
    static push_notifications = '/push_notifications';
    static push_notification_topics = '/push_notification_topics';
    static projectTypes = '/project_types';
    static donators = '/donators'
    static collaborators = '/collaborators'
    static supportedPeoples = '/supported_peoples';
    static feedbacks = '/feedbacks';
    static users = '/users';
}
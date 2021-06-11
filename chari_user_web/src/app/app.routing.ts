import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Import Containers
import { DefaultLayoutComponent } from './containers';

import { P404Component } from './views/error/404.component';
import { P500Component } from './views/error/500.component';
import { LoginComponent } from './views/login/login.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'dashboard',
    pathMatch: 'full',
  },
  {
    path: '404',
    component: P404Component,
    data: {
      title: 'Page 404'
    }
  },
  {
    path: '500',
    component: P500Component,
    data: {
      title: 'Page 500'
    }
  },
  {
    path: 'login',
    component: LoginComponent,
    data: {
      title: 'Trang đăng nhập'
    }
  },
  {
    path: '',
    component: DefaultLayoutComponent,
    data: {
      title: 'Trang chủ'
    },
    children: [
      {
        path: 'dashboard',
        loadChildren: () => import('./views/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: 'project',
        loadChildren: () => import('./views/project/project.module').then(m => m.ProjectModule)
      }, 
      {
        path: 'project-activating',
        loadChildren: () => import('./views/project-activating/project-activating.module').then(m => m.ProjectActivatingModule)
      },   
      {
        path: 'project-reached',
        loadChildren: () => import('./views/project-reached/project-reached.module').then(m => m.ProjectReachedModule)
      }, 
      {
        path: 'project-overdue',
        loadChildren: () => import('./views/project-overdue/project-overdue.module').then(m => m.ProjectOverdueModule)
      },   
      {
        path: 'project-closed',
        loadChildren: () => import('./views/project-closed/project-closed.module').then(m => m.ProjectClosedModule)
      },
      {
        path: 'posts',
        loadChildren: () => import('./views/post/post.module').then(m => m.ProjectPostModule)
      },
      {
        path: 'supported-people',
        loadChildren: () => import('./views/supported-people/supported-people.module').then(m => m.SupportedPeopleModule)
      },
      {
        path: 'feedback',
        loadChildren: () => import('./views/feedback/feedback.module').then(m => m.FeedbackModule)
      },
    ]
  },
  { path: '**', component: P404Component }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' }) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
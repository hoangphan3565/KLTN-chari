import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Import Containers
import { DefaultLayoutComponent } from './containers';

import { P404Component } from './views/error/404.component';
import { P500Component } from './views/error/500.component';
import { LoginComponent } from './views/login/login.component';
import { RegisterComponent } from './views/register/register.component';

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
    path: 'register',
    component: RegisterComponent,
    data: {
      title: 'Trang đăng ký'
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
        path: 'project-failed',
        loadChildren: () => import('./views/project-failed/project-failed.module').then(m => m.ProjectFailedModule)
      },   
      {
        path: 'project-unverified',
        loadChildren: () => import('./views/project-unverified/project-unverified.module').then(m => m.ProjectUnverifiedModule)
      },
      {
        path: 'project-type',
        loadChildren: () => import('./views/project-type/project-type.module').then(m => m.ProjectTypeModule)
      },
      {
        path: 'donator',
        loadChildren: () => import('./views/donator/donator.module').then(m => m.DonatorModule)
      },
      {
        path: 'supported-people',
        loadChildren: () => import('./views/supported-people/supported-people.module').then(m => m.SupportedPeopleModule)
      },
      {
        path: 'collaborator',
        loadChildren: () => import('./views/collaborator/collaborator.module').then(m => m.CollaboratorModule)
      },
      {
        path: 'push-notification',
        loadChildren: () => import('./views/push-notification/push-notification.module').then(m => m.PushNotificationModule)
      },
      {
        path: 'user',
        loadChildren: () => import('./views/user/user.module').then(m => m.UserModule)
      },
      {
        path: 'feedback',
        loadChildren: () => import('./views/feedback/feedback.module').then(m => m.FeedbackModule)
      },
      {
        path: 'base',
        loadChildren: () => import('./temp/base/base.module').then(m => m.BaseModule)
      },
      {
        path: 'buttons',
        loadChildren: () => import('./temp/buttons/buttons.module').then(m => m.ButtonsModule)
      },
      {
        path: 'charts',
        loadChildren: () => import('./temp/chartjs/chartjs.module').then(m => m.ChartJSModule)
      },
      {
        path: 'dashboard',
        loadChildren: () => import('./views/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: 'icons',
        loadChildren: () => import('./temp/icons/icons.module').then(m => m.IconsModule)
      },
      {
        path: 'notifications',
        loadChildren: () => import('./temp/notifications/notifications.module').then(m => m.NotificationsModule)
      },
      {
        path: 'theme',
        loadChildren: () => import('./temp/theme/theme.module').then(m => m.ThemeModule)
      },
      {
        path: 'widgets',
        loadChildren: () => import('./temp/widgets/widgets.module').then(m => m.WidgetsModule)
      }
    ]
  },
  { path: '**', component: P404Component }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' }) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
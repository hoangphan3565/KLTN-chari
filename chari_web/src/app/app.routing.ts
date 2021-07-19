import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import Cookies from 'js-cookie'

// Import Containers
import { DefaultLayoutComponent } from './containers';

import { P404Component } from './pages/error/404.component';
import { P500Component } from './pages/error/500.component';
import { LoginComponent } from './pages/login/login.component';

const islogged = Cookies.get("loginInfo");
export const routes: Routes = [
  {
    path: '',
    redirectTo: islogged==''?'login':'dashboard',
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
        path: islogged==''?'login':'dashboard',
        loadChildren: () => import('./views/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: islogged==''?'login':'project-activating',
        loadChildren: () => import('./views/project-activating/project-activating.module').then(m => m.ProjectActivatingModule)
      },   
      {
        path: islogged==''?'login':'project-reached',
        loadChildren: () => import('./views/project-reached/project-reached.module').then(m => m.ProjectReachedModule)
      }, 
      {
        path: islogged==''?'login':'project-overdue',
        loadChildren: () => import('./views/project-overdue/project-overdue.module').then(m => m.ProjectOverdueModule)
      },   
      {
        path: islogged==''?'login':'project-unverified',
        loadChildren: () => import('./views/project-unverified/project-unverified.module').then(m => m.ProjectUnverifiedModule)
      },
      {
        path: islogged==''?'login':'project-closed',
        loadChildren: () => import('./views/project-closed/project-closed.module').then(m => m.ProjectClosedModule)
      },
      {
        path: islogged==''?'login':'posts',
        loadChildren: () => import('./views/post/post.module').then(m => m.ProjectPostModule)
      },
      {
        path: islogged==''?'login':'project-type',
        loadChildren: () => import('./views/project-type/project-type.module').then(m => m.ProjectTypeModule)
      },
      {
        path: islogged==''?'login':'donator',
        loadChildren: () => import('./views/donator/donator.module').then(m => m.DonatorModule)
      },
      {
        path: islogged==''?'login':'supported-people',
        loadChildren: () => import('./views/supported-people/supported-people.module').then(m => m.SupportedPeopleModule)
      },
      {
        path: islogged==''?'login':'collaborator',
        loadChildren: () => import('./views/collaborator/collaborator.module').then(m => m.CollaboratorModule)
      },
      {
        path: islogged==''?'login':'user',
        loadChildren: () => import('./views/user/user.module').then(m => m.UserModule)
      },
      {
        path: islogged==''?'login':'feedback',
        loadChildren: () => import('./views/feedback/feedback.module').then(m => m.FeedbackModule)
      },
      {
        path: islogged==''?'login':'push-notification',
        loadChildren: () => import('./views/push-notification/push-notification.module').then(m => m.PushNotificationModule)
      },
      {
        path: islogged==''?'login':'supported-people-recommend',
        loadChildren: () => import('./views/supported-people-recommend/supported-people-recommend.module').then(m => m.SupportedPeopleRecommendModule)
      },

      // {
      //   path: 'base',
      //   loadChildren: () => import('./temp/base/base.module').then(m => m.BaseModule)
      // },
      // {
      //   path: 'buttons',
      //   loadChildren: () => import('./temp/buttons/buttons.module').then(m => m.ButtonsModule)
      // },
      // {
      //   path: 'charts',
      //   loadChildren: () => import('./temp/chartjs/chartjs.module').then(m => m.ChartJSModule)
      // },

      // {
      //   path: 'icons',
      //   loadChildren: () => import('./temp/icons/icons.module').then(m => m.IconsModule)
      // },
      // {
      //   path: 'notifications',
      //   loadChildren: () => import('./temp/notifications/notifications.module').then(m => m.NotificationsModule)
      // },
      // {
      //   path: 'theme',
      //   loadChildren: () => import('./temp/theme/theme.module').then(m => m.ThemeModule)
      // },
      // {
      //   path: 'widgets',
      //   loadChildren: () => import('./temp/widgets/widgets.module').then(m => m.WidgetsModule)
      // }
    ]
  },
  { path: '**', component: P404Component }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' }) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}

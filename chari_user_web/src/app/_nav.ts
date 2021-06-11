import { INavData } from '@coreui/angular';

export const navItems: INavData[] = [
  {
    name: 'Thống kê',
    url: '/dashboard',
    icon: 'icon-speedometer',
  },
  {
    title: true,
    name: 'Quản lý dự án'
  },
  {
    name: 'Dự án của tôi',
    url: '/project',
    icon: 'icon-check',
  },
  {
    name: 'Đang hoạt động',
    url: '/project-activating',
    icon: 'icon-fire',
  },
  {
    name: 'Đã thành công',
    url: '/project-reached',
    icon: 'icon-trophy',
  },
  {
    name: 'Đã quá hạn',
    url: '/project-overdue',
    icon: 'icon-close',
  },
  {
    name: 'Đã đóng',
    url: '/project-closed',
    icon: 'icon-ban',
  },
  {
    title: true,
    name: 'Quản lý tin tức'
  },
  {
    name: 'Tin tức',
    url: '/posts',
    icon: 'icon-speech',
  },
  {
    title: true,
    name: 'Quản lý chung'
  },
  {
    name: 'Đơn vị thụ hưởng',
    url: '/supported-people',
    icon: 'icon-star',
  },
  {
    title: true,
    name: 'Quản lý người dùng'
  },
  {
    name: 'Phản hồi',
    url: '/feedback',
    icon: 'icon-pencil',
  },
];

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
    name: 'Chờ phê duyệt',
    url: '/project-unverified',
    icon: 'icon-clock',
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
    name: 'Đã thất bại',
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
    name: 'Hoàn cảnh khác',
    url: '/supported-people-recommend',
    icon: 'icon-star',
  },
  {
    name: 'Người thụ hưởng',
    url: '/supported-people',
    icon: 'icon-star',
  },
  {
    name: 'Cộng tác viên',
    url: '/collaborator',
    icon: 'icon-people'
  },
  {
    name: 'Nhà hảo tâm',
    url: '/donator',
    icon: 'icon-heart'
  },
  {
    name: 'Gói từ thiện',
    url: '/project-type',
    icon: 'icon-book-open',
  },
  {
    name: 'Thông báo đẩy',
    url: '/push-notification',
    icon: 'icon-bell',
  },
  {
    title: true,
    name: 'Quản lý người dùng'
  },
  {
    name: 'Người dùng',
    url: '/user',
    icon: 'icon-user',
  },
  {
    name: 'Phản hồi',
    url: '/feedback',
    icon: 'icon-pencil',
  },

];

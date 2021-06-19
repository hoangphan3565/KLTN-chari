insert into jwt_user(username,password,usertype,status) values('collaborator_admin','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Collaborator','ACTIVATED');
insert into jwt_user(username,password,usertype,status) values('1231231232','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Collaborator','ACTIVATED');
insert into jwt_user(username,password,usertype,status) values('1231231233','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Collaborator','BLOCKED');
insert into jwt_user(username,password,usertype,status) values('4564564565','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Collaborator','ACTIVATED');

insert into jwt_user(username,password,usertype,status) values('1231231231','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Donator','ACTIVATED');
insert into jwt_user(username,password,usertype,status) values('4564564564','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Donator','ACTIVATED');
insert into jwt_user(username,password,usertype,status) values('7897897897','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Donator','NOT_ACTIVATED');

insert into jwt_user(username,password,usertype,status) values('admin','$2a$10$sszb2tF.4wuIvgsXpG8JDeRNNYsd0HfC0kEKJY./4OVLkEctyQ5tK','Admin','ACTIVATED');

insert into collaborator(username,is_accept,clb_id,full_name,phone_number,email,address,certificate) values('collaborator_admin',true,0,'Chari','admin','admin','TP HCM','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/collaborator_certificate%2Fdownload.png?alt=media&token=05502e8b-228c-4120-a04c-6c51e4440f26');
insert into collaborator(username,is_accept,full_name,phone_number,email,address,certificate) values('1231231232',true,'Nguyễn Minh Anh','1231231232','abc@gmail.com','TP Hà Nội','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/collaborator_certificate%2Fdownload.png?alt=media&token=05502e8b-228c-4120-a04c-6c51e4440f26');
insert into collaborator(username,is_accept,full_name,phone_number,email,address,certificate) values('4564564565',true,'Nguyễn Trần An','4564564565','abc@gmail.com','TP HCM','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/collaborator_certificate%2Fdownload.png?alt=media&token=05502e8b-228c-4120-a04c-6c51e4440f26');
insert into collaborator(username,is_accept,full_name,phone_number,email,address,certificate) values('1231231233',false,'Phan Văn B','4564564565','abc@gmail.com','TP HCM','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/collaborator_certificate%2Fdownload.png?alt=media&token=05502e8b-228c-4120-a04c-6c51e4440f26');


insert into donator(full_name,phone_number,address,favorite_project,favorite_notification,avatar_url) values('Phan Đình Hoàng','1231231231','Quận 1, TP Hà Nội','1 2 10 ','1 2 3 4 5 6 ','https://st.quantrimang.com/photos/image/2017/04/08/anh-dai-dien-FB-200.jpg');
insert into donator(full_name,phone_number,address,favorite_project,favorite_notification,avatar_url) values('Trần Văn Thường','4564564564','Quận 2, TP HCM','1 2 ','1 3 6 ','https://st.quantrimang.com/photos/image/2017/04/08/anh-dai-dien-FB-200.jpg');
insert into donator(full_name,phone_number,address,favorite_project,favorite_notification,avatar_url) values('Trần Văn Quân','7897897897','Quận 3, TP HCM','4 6 ','1 2 3 4 5 6 ','https://i.pinimg.com/originals/01/48/0f/01480f29ce376005edcbec0b30cf367d.jpg');

insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(false,'Sứ mệnh 1.000','Cùng Chari trên chặn đường xây dựng 1.000 điểm trường và mái ấm cho những hoàn cảnh khó khăn trên khắp đất nước.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fxay-truong-dung-uoc-mo.jpeg?alt=media&token=9aa38892-ed33-45b4-b4cb-17bfc9a43de1');
insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(true,'Hướng về miền Trung','Cùng chung tay ủng hộ bà con miền Trung vượt qua khó khăn mùa bão lũ.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fhuong-ve-mien-trung.png?alt=media&token=a4401234-f6b0-4b9c-b71b-7c722c4fa791');
insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(false,'Thắp sáng nụ cười','Cùng chung tay mang lại nụ cười, thay đổi cuộc sống cho trẻ em có hoàn cảnh khó khăn mắc các dị tật răng hàm mặt.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fthap-sang-nu-cuoi.jpeg?alt=media&token=3535c107-fd52-488c-a80f-e01336b7f6a0');
insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(false,'Đẩy lùi Covid-19','Cùng chung tay đẩy lùi đại dịch Covid-19.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fchung-tay-vuot-qua-dai-dich-covid.jpeg?alt=media&token=0e7eb4f8-2229-47f4-8edd-91d210ca1cce');
insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(true,'Bữa cơm từ thiện','Cùng Chari đóng góp những bữa cơm cho các hoàn cảnh khó khăn.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fbua-com-tu-thien.jpeg?alt=media&token=cb11ccc2-20cd-4832-b0a7-19efe4f543ff');
insert into project_type(can_disburse_when_overdue,project_type_name,description,image_url) values(false,'Quỹ Chari','Nơi đóng góp quỹ chung, chúng tôi sẽ thúc đẩy hoàn thành các đợt quyên góp sắp thành công.','https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/program%2Fquy-chari.png?alt=media&token=a64e5a72-953e-4a70-9612-65d1dbd4cef5');


insert into feedback(title,description,contributor) values('Thêm chức năng','Thực hiện quyên góp tiền qua ví Momo','Phan Đình Hoàng');
insert into feedback(title,description,contributor) values('Ứng dụng lag','Thao tác lướt ở trang chính ko được mượt mà','Nguyễn Văn Qúa');
insert into feedback(title,description,contributor) values('Thêm Zalopay','Thực hiện quyên góp tiền qví Zalopay','Phan Đình Hoàng');
insert into feedback(title,description,contributor) values('Làm lazy load','Làm lazy loading cho trang chính để ứng dụng mượt hơn','Phan Đình Hoàng');

insert into supported_people(clb_id,stp_id,full_name,address,phone_number,bank_name,bank_account) values(0,0,'PHAN DINH HOANG','TP HCM','0973465515','BIDV','31410002593895');
insert into supported_people(clb_id,full_name,address,phone_number,bank_name,bank_account) values(1,'TRAN THI BICH NGOC','Biên Hoà','0773453819','BIDV','31410004127254');
insert into supported_people(clb_id,full_name,address,phone_number,bank_name,bank_account) values(2,'NGUYEN THI NA','Lạng Sơn','0773453819','BIDV','31410004127254');
insert into supported_people(clb_id,full_name,address,phone_number,bank_name,bank_account) values(1,'QUY VAC-XIN PHONG COVID-19','Hà Nội','0773453819','BIDV','21110009116868');

insert into project(update_time,prj_id,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,prt_id,stp_id,clb_id)
values('2021-05-13 20:50:40.075187',0,'G0','Quỹ chung Chari',true,false,false,
       'Quỹ chung Chari là nơi thuận tiện nhất để mọi người quyên góp,',
       'Nếu bạn phân vân không biết nên ủng hộ cho hoàn cảnh nào là hợp lý, hãy ủng hộ ở đây chúng tôi sẽ cân nhắc các trường hợp khó khăn nhất hoặc những dự án sắp quyên góp thành công và chuyển số tiền này đến dự án đó. Tất cả số tiền của bạn trong quỹ này đều được thông báo khi được chúng tôi sử dụng, kèm theo những hình ảnh video chân thật nhất. ',
       '2020-11-01','2030-01-01',10000000,
       'https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/quy-chung-chari.jpeg?alt=media&token=e68a9642-dd1f-4f16-9138-95668c822403',6,0,0);


insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-23 20:50:40.075187','G10001','Hướng về miền Trung: Hỗ trợ gia đình 23 ngư dân Bình Định mất tích trên biển',true,false,false,
'Vợ chồng ông Đặng Văn Xang và bà Phan Thị Dốn (ở thôn Cửu Lợi Đông, P.Tam Quan Nam, TX.Hoài Nhơn) chỉ biết cầu trời khấn Phật phù hộ để lực lượng cứu hộ tìm được 2 con trai của mình...',
'       Những ngày qua, vợ chồng ông Đặng Văn Xang và bà Phan Thị Dốn (ở thôn Cửu Lợi Đông, P.Tam Quan Nam, TX.Hoài Nhơn)' ||
    'chỉ biết cầu trời khấn Phật phù hộ để lực lượng cứu hộ tìm được 2 con trai của mình là Đặng Đức Hiểu (24 tuổi) và Đặng Đức Nghĩa (20 tuổi). Vợ chồng ông Xang có 4 người con trai đi biển, trong đó anh em Hiểu và Nghĩa là thuyền viên tàu cá BĐ 96388 TS, còn 2 người con trai còn lại là Đặng Ngọc Mãi và Đặng Ngọc Thơi thì cùng đi đánh bắt trên một tàu cá khác.

        Chiều 27.10, khi tàu BĐ 96388 TS đang di chuyển tránh bão số 9 thì bị sóng đánh chìm, 12 ngư dân mất liên lạc cho ' ||
    'đến nay. Ngay trong đêm ấy, vợ chồng ông Xang nhận được tin tàu BĐ 96388 TS bị chìm, còn tàu cá mà anh Mãi và anh Thơi đang đánh bắt không thể di chuyển vì sóng gió quá mạnh, phải thả phao đứng im tại chỗ. Khi biết các con đang gặp nguy hiểm, bà Dốn đã ngất lịm. “Từ ngày đó đến nay, ngày nào gia đình cũng gọi điện đến đồn biên phòng và các cơ quan chức năng để hỏi về việc tìm kiếm các ngư dân mất tích, mà chưa ra”, ông Xang vừa khóc vừa kể.

        Không khí tang thương bao trùm lên ngôi nhà của thuyền trưởng tàu cá BĐ 96388 TS - ông Nguyễn Văn Minh (ở P.Tam ' ||
   'Quan Nam, TX.Hoài Nhơn). Vợ ông Minh là bà Trương Thị Nhung nằm mê man vì kiệt sức, hai đứa con mới 15 và 12 tuổi chỉ biết ôm mẹ mà khóc. Gia đình em gái ruột của bà Nhung là bà Trương Thị Kim Vân (ở KP.1, P.Tam Quan, H.Hoài Nhơn) cũng tràn ngập tang thương. Chồng bà Vân là ông Nguyễn Thanh Sỹ, thuyền viên tàu cá BĐ 96388 TS, hiện đang mất tích. Hầu hết các ngư dân trên tàu cá BĐ 96388 TS đều có hoàn cảnh khó khăn, nhiều người có con còn nhỏ hoặc có tuổi đời rất trẻ như: Võ Khôi Quốc mới 18 tuổi, Nguyễn Chí Khanh 19 tuổi…

        Ông Trương Đề, Phó chủ tịch UBND TX.Hoài Nhơn, cho biết chính quyền địa phương đã động viên, hỗ trợ gia đình các ' ||
   'ngư dân, hiện các tàu cứu hộ của lực lượng Kiểm ngư và Hải quân vùng 4 đang tiếp tục tổ chức tìm kiếm các ngư dân còn lại.

        Qua đây Chari kêu gọi các nhà hảo tâm cùng chung tay ủng hộ, giúp đỡ gia đình các ngư dân bị nạn, cũng như người ' ||
   'dân ở đây vượt qua được tình cảnh khó khăn này.
',
'2020-12-01','2021-03-15',1150000,
'https://cdnmedia.baotintuc.vn/Upload/OND64xLJqhpDJlQ2Gd1dpw/files/2020/11/ngu-dan-gap-nan-31120.jpg',
'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project001.mp1?alt=media&token=f3ae0a28-e1fb-4438-a156-1fc73dfc7c55',2,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-22 20:50:40.075187','G10002','Chia sẻ khó khăn học sinh nghèo vùng biên giới',true,false,false,
'Năm học 2019 - 2020 trường có hơn 600 học sinh  được chia thành 21 lớp, học sinh nơi đây chủ yếu là con em đồng bào dân tộc thiểu số (Jrai), đời sống còn quá khó khăn...',
'       Trường Tiểu học Cù Chính Lan của huyện Ia Grai, tỉnh Gia Lai là một trường vùng biên giới giáp với Campuchia. Năm học 2019 - 2020 trường có hơn 600 học sinh  được chia thành 21 lớp, học sinh nơi đây chủ yếu là con em đồng bào dân tộc thiểu số (Jrai), đời sống còn quá khó khăn.
' ||
'      Để chuẩn bị cho năm học mới, làm sao cho các em học sinh có đủ sách giáo khoa, có đồng phục đến trường đó là sự trăn trở của tập thể giáo viên và phụ huynh học sinh Trường Tiểu học Cù Chính Lan và đặc biệt đây là năm đầu tiên Trường Tiểu học Cù Chính Lan triển khai cho học sinh mặc đồng phục đến trường, mong muốn từng bước chuẩn hoá môi trường học ngày càng tốt hơn. Tuy nhiên có nhiều phụ huynh học sinh, nhất là đồng bào dân tộc, quá khó khăn không có khả năng để trang bị cho con. Thực tế là các em học sinh gia đình nghèo không thể có đủ sách và đồng phục đến trường cùng các bạn. Dự kiến tài trợ:
            -	250 bộ Sách giáo khoa từ lớp 1 đến  lớp 5, mỗi khối 50 bộ: 33.352.000 đ
            -	200 bộ áo quần đồng phục:  26.000.000 đ
            -	200 áo khoác cho các em đến trường trong thời tiết lạnh: 16.000.000đ
        Tổng số tiền tài trợ là: 75.352.000 đồng.' ||
         '
        Rất mong quý nhà hảo tâm cùng Chari chung tay ủng hộ cho các em học sinh biên giới có cơ hội được cắp sách tới trường, thực hiện ước mơ học tập của em, nâng bước các em tới tương lai tươi đẹp hơn.',
'2020-12-01','2021-05-31',750000,
'https://www.giaoduc.edu.vn/upload/images/2011/10/02/hinh-anh-hoc-tro-ngheo-dung-quan-tai-lam-ghe-rung-dong-cong-dong_11.jpg',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',1,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-27 20:50:40.075187','G10003','Tài trợ xe lăn/ xe lắc cho người khuyết tật tại tỉnh Thừa Thiên Huế',true,false,false,
'Trong đợt này, thị xã Hương có 30 người khuyết tật được trao tặng xe lăn, mỗi chiếc trị giá hơn 2 triệu đồng...',
'       Thông qua nguồn tài trợ của tổ chức Trả lại tuổi thơ (Hoa Kỳ), Hội Chữ thập đỏ, Hội Người khuyết tật thị xã Hương Thủy phối hợp với Hội Bảo trợ Người tàn tật và Trẻ mồ côi tỉnh Thừa Thiên Huế và Ứng dụng Chari, dự định tổ chức trao xe lăn cho người khuyết tật trên địa bàn.
' ||
'       Trong đợt này, thị xã Hương có 30 người khuyết tật được trao tặng xe lăn, mỗi chiếc trị giá hơn 2 triệu đồng. Đây là loại xe lăn có nhiều ưu điểm vượt trội, nhỏ, gọn, có thể tùy chỉnh chỗ gác chân phù hợp, ghế ngồi được thiết kế bằng nhựa dẻo cao cấp, thuận tiện tắm rửa trực tiếp trên xe mà không cần thay đổi ghế ngồi.
' ||
'       Việc trao tặng xe lăn sẽ góp phần hỗ trợ đắc lực cho người khuyết tật có thể tự di chuyển thuận lợi và dễ dàng, giảm bớt gánh nặng chăm sóc cho người thân; giúp người khuyết tật có thêm tự tin, nỗ lực vươn lên trong cuộc sống.
' ||
'       Được biết, năm 2019, Hội Bảo trợ Người tàn tật và Trẻ mồ côi tỉnh tiếp nhận 678 chiếc xe lăn do tổ chức Trả lại tuổi thơ (Hoa Kỳ) tài trợ để cấp phát miễn phí cho người khuyết tật trên địa bàn tỉnh Thừa Thiên Huế.',
'2020-11-01','2021-07-01',700000,
'https://baodansinh.mediacdn.vn/2019/9/25/20180831khuyettat2-156937253284583232848-crop-15693726108981781484170.jpg',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',1,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-21 20:50:40.075187','G10004','Hỗ trợ vốn sinh kế cho người khuyết tật tỉnh Tây Ninh',true,false,false,
'Trên địa bàn tỉnh Tây Ninh có khoảng 57.000 người khuyết tật...',
'       Do tình hình của dịch COVID-19 kéo dài đã ảnh hưởng rất nhiều tới đời sống của người dân Việt Nam. Rất nhiều gia đình gặp tình trạng đói kém, mất việc làm và ảnh hưởng tới cuộc sống hằng ngày.
' ||
'       Trên địa bàn tỉnh Tây Ninh có khoảng 57.000 người khuyết tật, cuộc sống thường ngày của họ đã khó khăn thì nay càng khó khăn hơn khi gặp phải tình hình dịch bệnh kéo dài  như hiện nay.
' ||
'       Vấn đề việc làm của người khuyến tật ở Việt Nam còn gặp nhiều trở ngại, mặc dù nhà nước đã đưa ra nhiều chính sách hỗ trợ cho doanh nghiệp nhưng người khuyết tật lại không có nhiều cơ hội để tìm kiếm việc làm. Tại Việt Nam các trung tâm tư vấn, giới thiệu việc làm cho người khuyết tật còn hạn hẹp chưa phổ biến. Điều này dẫn tới chưa thể tiếp cận tới vấn đề việc làm cho người khuyết tật.
' ||
'       Do đó, Chari cùng với các đơn vị đồng hành mong muốn góp một phần nhỏ của mình để giúp đỡ người khuyết tật có vốn ban đầu hỗ trợ cho công việc của họ sau này.',
'2020-11-01','2021-03-01',1000000,
'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',1,2,2);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-25 20:50:40.075187','G10005','Hỗ trợ "cặp phao" cứu sinh cho các em học sinh ',true,true,false,
'Khác với học sinh vùng xuôi, con đường tìm đến con chữ của học sinh miền núi, vùng sâu, vùng xa ở tỉnh Quảng Ngãi còn gặp rất nhiều khó khăn, trắc trở...',
'       Để “kiếm” con chữ, mỗi ngày, hàng trăm học sinh ở xã vùng cao Ba Vì, huyện miền núi Ba Tơ (Quảng Ngãi) phải bất chấp nguy hiểm lội bộ qua dòng suối chảy xiết để đến trường với bao hiểm họa giăng ra trước mắt.
' ||
'       Dù chỉ mới học lớp 1, nhưng Phạm Thị Nói (xã Ba Vì) vẫn ngày ngày bất chấp nguy hiểm tự vượt qua con suối Nước Ui để đến với Trường tiểu học Ba Vì theo học con chữ. Ba mẹ lên núi làm rẫy nên Nói phải đến trường một mình. Không ít lần qua suối, Nói bị trượt chân, té ngã, nước cuốn trôi, ướt cả quần áo nhưng em vẫn cố gắng đến trường.
' ||
'       Con suối Nước Ui đang trong mùa nước lớn nhưng vì không có cầu nên hàng trăm học sinh vẫn phải băng qua con suối này. Ðể an toàn cho học sinh, người dân dùng đá kè ngang suối để các em xác định đường đi, tránh đi phải vào chỗ nước sâu, tập hợp thành nhóm để hỗ trợ nhau nếu gặp sự cố. Nhiều gia đình còn phải gác lại việc nương rẫy cõng con qua suối đến trường những ngày trời mưa.
' ||
'       Xã Ba Vì có 6 thôn thì có đến 4 thôn thường xuyên bị cô lập vào mùa mưa lũ. Khoảng 300 học sinh hằng ngày phải vượt suối đến trường. Mùa cạn, các em còn đi học được, nhưng chỉ cần một trận mưa là nước suối lại dâng cao, các em phải nghỉ học.
' ||
'       Hiện nay đang là mùa mưa lũ, vì vậy chuyện vượt suối đi học càng trở nên khó khăn, nguy hiểm đối với với nhiều học sinh ở xã vùng cao Ba Vì. Trước mắt, chính quyền địa phương vận động nhân dân tiếp tục cắt cử nhau đưa con em qua suối đi học, nhưng về lâu dài, cần đầu tư xây dựng hệ thống đường, cầu thì mỗi ngày đến trường mới đúng nghĩa là một ngày vui, ngày an toàn đối với học sinh nơi đây.
' ||
'       Mong muốn hoàn thành giấc mơ xây cầu cho các em nhưng còn gặp nhiều khó khăn về mặt pháp lý, nên thời điểm hiện tại để kịp thời giúp đỡ các em Chari kêu gọi các nhà hảo tâm quyên góp tặng cho các em những chiếc “Cặp phao” để các em phần nào an toàn hơn trên con đường đến trường đầy chông gai, nguy hiểm.',
'2020-11-15','2021-02-15',700000,
'https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',
'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project005.mp1?alt=media&token=b7e2d9cf-3240-42b7-b4ef-1985f252a34a',1,2,2);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-29 20:50:40.075187','G10006','Xây cầu tình thương cho thôn Diêm Vân',false,false,false,
'Nín thở đi qua cầu gỗ ọp ẹp tại thôn Diêm Vân, xã Phước Thuận, tỉnh Bình Định...',
'       Nhiều năm qua, người dân xóm 3 (thôn Diêm Vân, xã Phước Thuận, tỉnh Bình Định) phải tự sửa chữa, gia cố cây cầu tạm bằng gỗ đã xuống cấp trầm trọng để làm nơi qua lại.
' ||
'       Hiện tại, các trụ cầu đều đã xiêu vẹo, một số trụ thậm chí bị gãy phần xi măng chỉ còn dính vài cây sắt nhỏ. Những trụ khác bị gãy được người dân dùng cây gỗ để gia cố một cách tạm bợ. Mặt cầu rộng chỉ chừng 1m được lót bằng những tấm gỗ nhưng đã mục nát, hai bên cầu không có lan can bảo vệ. Chỉ cần một người đi bộ, cầu cũng bị rung lắc mạnh như muốn sập xuống sông. Đáng lo ngại là trên đường tới trường hàng ngày, các em học sinh trong xóm vẫn phải đi qua cây cầu này.
' ||
'       Người dân thôn Diêm Vân cho biết, từ năm 2012 đến đầu năm 2018, Ban nhân dân thôn Diêm Vân và UBND xã Phước Thuận đã 2 lần tổ chức đấu giá ngòi (còn gọi là lạch Ân Thuận) để làm cầu dân sinh nối liền 2 khu dân cư ở bờ bắc và bờ nam của thôn, với số tiền 90 triệu đồng. Nhưng tới nay cầu vẫn chưa được xây dựng. Lãnh đạo xã Phước Thuận cho biết, số tiền kinh phí đang có của địa phương là 90 triệu đồng, trong khi xây cầu mới dự toán khoảng 250 triệu đồng.
' ||
'       Để giúp đỡ cho người dân có cây cầu đi lại an toàn hơn, không xảy ra những vụ việc đáng tiếc mà ta có thể biết trước nhưng không thể ngăn chặn, thì Chari mong muốn góp một phần nhỏ để giúp đỡ cho chính quyền có đủ kinh phí xây dựng, giúp người dân mau chóng có một cây cầu mới để đi lại an toàn. ',
'2020-11-01','2021-11-29',1500000,
'https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/unnamed.jpeg?alt=media&token=2984e9d7-c37d-4201-9d6e-ccecaea19b05',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',1,2,2);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-28 20:50:40.075187','G10007','Xây dựng tủ sách cho học sinh nghèo vùng cao',false,false,false,
'Giúp học sinh nghèo vững bước tới trường với một tủ sách khang trang chống mưa...',
'       Ðầu năm học mới, chi phí mua sắm sách giáo khoa, đồ dùng học tập cho học sinh đến trường  luôn là nỗi lo của những gia đình có điều kiện kinh tế khó khăn. Trong khi học sinh ở thành phố lúc nào cũng đầy đủ sách giáo khoa, đồ dùng học tập thì học sinh ở khu vực nông thôn, miền núi hay vùng cao lại rơi vào cảnh  thiếu sách để học. Nhiều  học sinh phải học chung một quyển sách, có những quyển được tận dụng tới ba, bốn năm, đến khi sách quá cũ, không thể dùng được nữa  mới bỏ đi. Trong khi đó ở thành phố, mỗi năm học sinh lại thay một bộ sách mới, sách giáo khoa cũ  không được tận dụng lại cho các  lớp sau.
' ||
'       Phong trào quyên góp, ủng hộ sách giáo khoa cho học sinh vùng khó khăn từ lâu đã trở thành   cuộc vận động lớn, được thực hiện thường xuyên, liên tục. Tạo điều kiện hỗ trợ học sinh nghèo khó khăn vững bước đến trường không chỉ là việc làm của riêng ngành GD và ÐT, mà cần sự chung tay, góp sức của toàn xã hội.
' ||
'       Do đó Chari muốn thay mặt các nhà hảo tâm đóng góp một phần nhỏ vào việc xây dựng tủ sách cho các em học sinh nghèo vùng cao để năm học sắp tới các em có đầy đủ sách giáo khoa mới, và những cuốn sách thuộc nhiều lĩnh vực khác giúp các em thỏa thích tìm hiểu và đọc sách.',
'2020-9-30','2021-11-30',1000000,
'https://ktktlaocai.edu.vn/wp-content/uploads/2019/10/tre-em-vung-cao-kho-khan-1.jpg',
'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project007.mp1?alt=media&token=e22d6351-404d-4f7f-947d-9e580e776030',1,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-19 20:50:40.075187','G10008','Xây dựng khu vui chơi trong sân trường cho trường tiểu học Thanh Kim (Lào Cai)',true,false,true,

'Trường Tiểu học Thanh Kim, thuộc xã Thanh Kim (huyện Sa Pa, tỉnh Lào Cai)...',
'       Trường Tiểu học Thanh Kim, thuộc xã Thanh Kim (huyện Sa Pa, tỉnh Lào Cai). Đây là một trong những xã thuộc Chương trình 135 (chương trình hỗ trợ phát triển kinh tế xã hội các xã đặc biệt khó khăn vùng dân tộc thiểu số và miền núi).
' ||
'       Theo chia sẻ của thầy Nguyễn Đắc Chiến (Phó hiệu trưởng phụ trách trường Tiểu học Thanh Kim), năm học mới, trường có 267 học sinh, chia thành 16 lớp từ lớp 1-5. 99% học sinh là dân tộc Dao, Mông; 1/3 trong số đó thuộc hộ nghèo, cận nghèo.
' ||
'       Việc đi học đã khó khăn, thì việc có một khu vui chơi đối với các em nhỏ vùng cao này gần như là không dám mơ ước tới. Khi chúng tôi tới khảo sát và hỏi các em về những thứ các em chơi hàng ngày, thì các em trả lời đó chỉ là vài tàu lá chuối, những cục đá cục sỏi, hay có những em còn không có thời gian để chơi vì phụ giúp bố mẹ nương rẫy.
' ||
'       Với sự ngây ngô của các em, chúng tôi muốn xây dựng cho các em một khu vui chơi nho nhỏ nằm trong sân trường để các em có thể chơi đùa, vận động cùng nhau. Dù chỉ là những trò chơi đơn giản nhưng cũng đủ giúp các em không còn phải nghịch đất sỏi trên đường.',
'2020-11-20','2021-03-01',830000,
'https://baotuyenquang.com.vn/media/images/2018/04/img_20180404092429.jpg',
'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project008.mp1?alt=media&token=04d75437-7c92-46c6-872a-107f4bdd3e89',1,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-27 20:50:40.075187','G20002','Xây cầu tình thương cho làng An Phú 9',true,false,false,
'Làng An Phú 9 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày',
'Làng An Phú 9 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày. Làng An Phú 1 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày. Làng An Phú 1 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày',
'2020-11-01','2021-08-01',400000,
'https://afamilycdn.com/zoom/640_400/2019/1/23/421a5765-15482290750161494101089-crop-1548229105336344905179.jpg',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',2,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-24 20:50:40.075187','G300001','Ủng hộ 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10',true,false,false,
'Anh Hùng là đầu bếp có tâm, từng bỏ tiền túi để nấu 100 phần cơm cho bệnh nhân khó khăn ở quận 10',
'Làng An Phú 10 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày. Làng An Phú 1 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày. Làng An Phú 1 có nhiều sông ngòi cần xây cầu cho học sinh đi học hằng ngày',
'2020-11-01','2021-03-01',200000,
'https://hieuvetraitim.com/attachments/hoan-canh-gioi-thieu-jpg.1782/',
'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp1',5,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-18 20:50:40.075187','G10009','Hướng về miền Trung: Hỗ trợ gia đình mất nhà do bão',true,false,false,
       'Vợ chồng ông Đặng Văn Xang và bà Phan Thị Dốn (ở thôn Cửu Lợi Đông, P.Tam Quan Nam, TX.Hoài Nhơn) chỉ biết cầu trời khấn Phật phù hộ để lực lượng cứu hộ tìm được 2 con trai của mình...',
       '       Những ngày qua, vợ chồng ông Đặng Văn Xang và bà Phan Thị Dốn (ở thôn Cửu Lợi Đông, P.Tam Quan Nam, TX.Hoài Nhơn)' ||
       'chỉ biết cầu trời khấn Phật phù hộ để lực lượng cứu hộ tìm được 2 con trai của mình là Đặng Đức Hiểu (24 tuổi) và Đặng Đức Nghĩa (20 tuổi). Vợ chồng ông Xang có 4 người con trai đi biển, trong đó anh em Hiểu và Nghĩa là thuyền viên tàu cá BĐ 96388 TS, còn 2 người con trai còn lại là Đặng Ngọc Mãi và Đặng Ngọc Thơi thì cùng đi đánh bắt trên một tàu cá khác.

           Chiều 27.10, khi tàu BĐ 96388 TS đang di chuyển tránh bão số 9 thì bị sóng đánh chìm, 12 ngư dân mất liên lạc cho ' ||
       'đến nay. Ngay trong đêm ấy, vợ chồng ông Xang nhận được tin tàu BĐ 96388 TS bị chìm, còn tàu cá mà anh Mãi và anh Thơi đang đánh bắt không thể di chuyển vì sóng gió quá mạnh, phải thả phao đứng im tại chỗ. Khi biết các con đang gặp nguy hiểm, bà Dốn đã ngất lịm. “Từ ngày đó đến nay, ngày nào gia đình cũng gọi điện đến đồn biên phòng và các cơ quan chức năng để hỏi về việc tìm kiếm các ngư dân mất tích, mà chưa ra”, ông Xang vừa khóc vừa kể.

           Không khí tang thương bao trùm lên ngôi nhà của thuyền trưởng tàu cá BĐ 96388 TS - ông Nguyễn Văn Minh (ở P.Tam ' ||
       'Quan Nam, TX.Hoài Nhơn). Vợ ông Minh là bà Trương Thị Nhung nằm mê man vì kiệt sức, hai đứa con mới 15 và 12 tuổi chỉ biết ôm mẹ mà khóc. Gia đình em gái ruột của bà Nhung là bà Trương Thị Kim Vân (ở KP.1, P.Tam Quan, H.Hoài Nhơn) cũng tràn ngập tang thương. Chồng bà Vân là ông Nguyễn Thanh Sỹ, thuyền viên tàu cá BĐ 96388 TS, hiện đang mất tích. Hầu hết các ngư dân trên tàu cá BĐ 96388 TS đều có hoàn cảnh khó khăn, nhiều người có con còn nhỏ hoặc có tuổi đời rất trẻ như: Võ Khôi Quốc mới 18 tuổi, Nguyễn Chí Khanh 19 tuổi…

            Ông Trương Đề, Phó chủ tịch UBND TX.Hoài Nhơn, cho biết chính quyền địa phương đã động viên, hỗ trợ gia đình các ' ||
       'ngư dân, hiện các tàu cứu hộ của lực lượng Kiểm ngư và Hải quân vùng 4 đang tiếp tục tổ chức tìm kiếm các ngư dân còn lại.

            Qua đây Chari kêu gọi các nhà hảo tâm cùng chung tay ủng hộ, giúp đỡ gia đình các ngư dân bị nạn, cũng như người ' ||
       'dân ở đây vượt qua được tình cảnh khó khăn này.
    ',
       '2020-12-01','2021-03-15',1150000,
       'https://thukyluat.vn/uploads/image/2020/11/06/Ho-so-thu-tuc-nhan-tien-ho-tro-sap-nha-o-do-thien-tai-bao-lut-gay-ra.jpg',
       'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project001.mp1?alt=media&token=f3ae0a28-e1fb-4438-a156-1fc73dfc7c55',2,1,1);

insert into project(update_time,project_code,project_name,verified,disbursed,closed,brief_description,description,start_date,end_date,target_money,image_url,video_url,prt_id,stp_id,clb_id)
values('2021-05-15 20:50:40.075187','G10010','Xây dựng sân trường cho trường tiểu học Quảng Thành',true,false,true,

       'Trường Tiểu học Thanh Kim, thuộc xã Thanh Kim (huyện Sa Pa, tỉnh Lào Cai)...',
       '       Trường Tiểu học Thanh Kim, thuộc xã Thanh Kim (huyện Sa Pa, tỉnh Lào Cai). Đây là một trong những xã thuộc Chương trình 135 (chương trình hỗ trợ phát triển kinh tế xã hội các xã đặc biệt khó khăn vùng dân tộc thiểu số và miền núi).
       ' ||
       '       Theo chia sẻ của thầy Nguyễn Đắc Chiến (Phó hiệu trưởng phụ trách trường Tiểu học Thanh Kim), năm học mới, trường có 267 học sinh, chia thành 16 lớp từ lớp 1-5. 99% học sinh là dân tộc Dao, Mông; 1/3 trong số đó thuộc hộ nghèo, cận nghèo.
       ' ||
       '       Việc đi học đã khó khăn, thì việc có một khu vui chơi đối với các em nhỏ vùng cao này gần như là không dám mơ ước tới. Khi chúng tôi tới khảo sát và hỏi các em về những thứ các em chơi hàng ngày, thì các em trả lời đó chỉ là vài tàu lá chuối, những cục đá cục sỏi, hay có những em còn không có thời gian để chơi vì phụ giúp bố mẹ nương rẫy.
       ' ||
       '       Với sự ngây ngô của các em, chúng tôi muốn xây dựng cho các em một khu vui chơi nho nhỏ nằm trong sân trường để các em có thể chơi đùa, vận động cùng nhau. Dù chỉ là những trò chơi đơn giản nhưng cũng đủ giúp các em không còn phải nghịch đất sỏi trên đường.',
       '2020-11-20','2021-03-01',830000,
       'https://photo-cms-giaoduc.zadn.vn/w700/Uploaded/2021/juznus/2020_10_21/gdvn-truonghocsaulu7-giaoduc-net-vn-3067.jpg',
       'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project008.mp1?alt=media&token=04d75437-7c92-46c6-872a-107f4bdd3e89',1,1,1);

insert into project_images(image_url,prj_id) values('https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/quy-chung-chari.jpeg?alt=media&token=e68a9642-dd1f-4f16-9138-95668c822403',0);
insert into project_images(image_url,prj_id) values('https://media.laodong.vn/Storage/NewsPortal/2020/10/29/849812/Lai-Dat-Tau-Bi-Nan-B.jpg?w=414&h=276&crop=auto&scale=both',1);
insert into project_images(image_url,prj_id) values('https://cdnimg.vietnamplus.vn/t620/uploaded/fsmsy/2020_11_03/ttxvn_ngu_dan_binh_dinh_2.jpg',1);
insert into project_images(image_url,prj_id) values('https://cdnmedia.baotintuc.vn/Upload/DmtgOUlHWBO5POIHzIwr1A/files/2020/11/03/ngu-dan-031120.jpg',1);
insert into project_images(image_url,prj_id) values('https://cdnmedia.baotintuc.vn/Upload/OND64xLJqhpDJlQ2Gd1dpw/files/2020/11/ngu-dan-gap-nan-31120.jpg',1);
insert into project_images(image_url,prj_id) values('https://cdnimg.vietnamplus.vn/t620/uploaded/xpcwvovt/2020_10_29/ttxvn_tau_kiem_ngu.jpg',1);
insert into project_images(image_url,prj_id) values('https://www.giaoduc.edu.vn/upload/images/2011/10/02/hinh-anh-hoc-tro-ngheo-dung-quan-tai-lam-ghe-rung-dong-cong-dong_11.jpg',2);
insert into project_images(image_url,prj_id) values('https://tamnguyenviet.vn/wp-content/uploads/2019/11/truong.jpg',2);
insert into project_images(image_url,prj_id) values('https://files.giaoducthoidai.vn/Uploaded/nhungnt/2014_02_17/1_JYGD.jpg',2);
insert into project_images(image_url,prj_id) values('https://gialai.gov.vn/Lists/TinTucSuKien/Attachments/63615/giao%20duc.jpg',2);
insert into project_images(image_url,prj_id) values('https://www.bienphong.com.vn//images/media/oldimages/qajf_5a_w550.JPG',2);
insert into project_images(image_url,prj_id) values('https://vnn-imgs-f.vgcloud.vn/2020/09/05/09/bac-ly-10.jpg',2);
insert into project_images(image_url,prj_id) values('https://baodansinh.mediacdn.vn/2019/9/25/20180831khuyettat2-156937253284583232848-crop-15693726108981781484170.jpg',3);
insert into project_images(image_url,prj_id) values('https://baothuathienhue.vn/image/fckeditor/upload/2019/20190517/images/x2.jpg',3);
insert into project_images(image_url,prj_id) values('https://baothuathienhue.vn/image/fckeditor/upload/2017/20171202/images/giup-nguoi.jpg',3);
insert into project_images(image_url,prj_id) values('https://thoidai.com.vn/stores/news_dataimages/anh.van/052020/20/13/sen-vang-berlin-trao-tang-10-xe-lan-cho-nguoi-khuyet-tat-tinh-thua-thien-hue.jpg',3);
insert into project_images(image_url,prj_id) values('https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG',4);
insert into project_images(image_url,prj_id) values('https://baotayninh.vn/image/fckeditor/upload/2020/20200814/images/diem-tin-3.jpg',4);
insert into project_images(image_url,prj_id) values('https://baolongan.vn/image/news/2020/20200108/thumbnail/510x286/839_1578488896.jpg',4);
insert into project_images(image_url,prj_id) values('https://baogialai.com.vn/dataimages/201904/original/images2761149_1.jpghttps://baogialai.com.vn/dataimages/201904/original/images2761149_1.jpg',4);
insert into project_images(image_url,prj_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',5);
insert into project_images(image_url,prj_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',5);
insert into project_images(image_url,prj_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',5);
insert into project_images(image_url,prj_id) values('https://anh.eva.vn//upload/3-2015/images/2015-09-08/1441684268-11992496_1627825204133394_783327606_n.jpg',5);
insert into project_images(image_url,prj_id) values('https://mb.dkn.tv/wp-content/uploads/2015/09/kinh-so-canh-hang-tram-nguoi-dan-lieu-minh-du-day-cap-vuot-suoi.jpg',5);
insert into project_images(image_url,prj_id) values('https://anh.24h.com.vn/upload/4-2014/images/2014-11-30/1417327823-vuot-suoi-den-truong-1.jpg',5);
insert into project_images(image_url,prj_id) values('https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/unnamed.jpeg?alt=media&token=2984e9d7-c37d-4201-9d6e-ccecaea19b05',6);
insert into project_images(image_url,prj_id) values('https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/unnamed.jpeg?alt=media&token=2984e9d7-c37d-4201-9d6e-ccecaea19b05',6);
insert into project_images(image_url,prj_id) values('https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/unnamed.jpeg?alt=media&token=2984e9d7-c37d-4201-9d6e-ccecaea19b05',6);
insert into project_images(image_url,prj_id) values('https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/unnamed.jpeg?alt=media&token=2984e9d7-c37d-4201-9d6e-ccecaea19b05',6);
insert into project_images(image_url,prj_id) values('https://sites.google.com/site/phanthingochang290118/_/rsrc/1517397505028/tham-khao/hang9.jpg',7);
insert into project_images(image_url,prj_id) values('https://vnn-imgs-f.vgcloud.vn/2018/02/08/17/canh-hoc-sinh-vung-cao-an-com-tron-mi-tom-ngon-lanh-khien-nhieu-nguoi-xot-xa-7.jpg',7);
insert into project_images(image_url,prj_id) values('https://giacmovietnam.files.wordpress.com/2013/12/008.jpg',7);
insert into project_images(image_url,prj_id) values('https://ktktlaocai.edu.vn/wp-content/uploads/2019/10/tre-em-vung-cao-kho-khan-1.jpg',7);
insert into project_images(image_url,prj_id) values('https://image.sggp.org.vn/w580/Uploaded/2020/evesfnbfjpy/2019_10_19/s3b_rncg.jpg',7);
insert into project_images(image_url,prj_id) values('http://tinhdoannghean.vn/images/news/yenthanh_khuvuichoi_1_8_2018.jpg',8);
insert into project_images(image_url,prj_id) values('http://tinhdoannghean.vn/images/news/yenthanh_khuvuichoi_3_8_2018.jpg',8);
insert into project_images(image_url,prj_id) values('http://tinhdoannghean.vn/images/news/yenthanh_khuvuichoi_4_8_2018.jpg',8);
insert into project_images(image_url,prj_id) values('https://tuoitrebudop.org.vn/uploads/news/2019_10/h17.jpg',8);
insert into project_images(image_url,prj_id) values('https://baotuyenquang.com.vn/media/images/2018/04/img_20180404092429.jpg',8);
insert into project_images(image_url,prj_id) values('https://baoxaydung.com.vn/stores/news_dataimages/vananh/102020/24/12/in_article/5733_image001.jpg',9);
insert into project_images(image_url,prj_id) values('https://media.truyenhinhdulich.vn/upload/news/2127_cau_khi_viet_nam_lot_top_nhung_cay_cau_dang_so_nha.jpg',9);
insert into project_images(image_url,prj_id) values('https://afamilycdn.com/zoom/640_400/2019/1/23/421a5765-15482290750161494101089-crop-1548229105336344905179.jpg',9);
insert into project_images(image_url,prj_id) values('https://baoxaydung.com.vn/stores/news_dataimages/vananh/102020/24/12/in_article/5733_image001.jpg',10);
insert into project_images(image_url,prj_id) values('https://media.truyenhinhdulich.vn/upload/news/2127_cau_khi_viet_nam_lot_top_nhung_cay_cau_dang_so_nha.jpg',10);
insert into project_images(image_url,prj_id) values('https://afamilycdn.com/zoom/640_400/2019/1/23/421a5765-15482290750161494101089-crop-1548229105336344905179.jpg',10);
insert into project_images(image_url,prj_id) values('https://baoxaydung.com.vn/stores/news_dataimages/vananh/102020/24/12/in_article/5733_image001.jpg',11);
insert into project_images(image_url,prj_id) values('https://media.truyenhinhdulich.vn/upload/news/2127_cau_khi_viet_nam_lot_top_nhung_cay_cau_dang_so_nha.jpg',11);
insert into project_images(image_url,prj_id) values('https://afamilycdn.com/zoom/640_400/2019/1/23/421a5765-15482290750161494101089-crop-1548229105336344905179.jpg',11);
insert into project_images(image_url,prj_id) values('https://baoxaydung.com.vn/stores/news_dataimages/vananh/102020/24/12/in_article/5733_image001.jpg',12);
insert into project_images(image_url,prj_id) values('https://media.truyenhinhdulich.vn/upload/news/2127_cau_khi_viet_nam_lot_top_nhung_cay_cau_dang_so_nha.jpg',12);
insert into project_images(image_url,prj_id) values('https://afamilycdn.com/zoom/640_400/2019/1/23/421a5765-15482290750161494101089-crop-1548229105336344905179.jpg',12);


insert into donate_activity(dnt_id,prj_id,status) values(1,1,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',150000,1);
insert into donate_activity(dnt_id,prj_id,status) values(1,2,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',10000,2);
insert into donate_details(donate_date,money,dna_id) values('2020-11-20',150000,2);
insert into donate_activity(dnt_id,prj_id,status) values(1,3,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',180000,3);
insert into donate_activity(dnt_id,prj_id,status) values(1,4,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',900000,4);
insert into donate_activity(dnt_id,prj_id,status) values(1,5,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',700000,5);
insert into donate_activity(dnt_id,prj_id,status) values(2,1,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-01',90000,6);
insert into donate_activity(dnt_id,prj_id,status) values(2,2,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',12000,7);
insert into donate_details(donate_date,money,dna_id) values('2020-11-03',3000,7);
insert into donate_activity(dnt_id,prj_id,status) values(2,3,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-13',90000,8);
insert into donate_activity(dnt_id,prj_id,status) values(2,4,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',90000,9);
insert into donate_activity(dnt_id,prj_id,status) values(2,10,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',60000,10);
insert into donate_details(donate_date,money,dna_id) values('2020-11-08',40000,10);
insert into donate_activity(dnt_id,prj_id,status) values(1,11,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',800000,11);
insert into donate_details(donate_date,money,dna_id) values('2020-11-07',250000,11);
insert into donate_activity(dnt_id,prj_id,status) values(1,8,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-08',80000,12);
insert into donate_activity(dnt_id,prj_id,status) values(1,12,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',40000,13);
insert into donate_activity(dnt_id,prj_id,status) values(1,10,'SUCCESSFUL');
insert into donate_details(donate_date,money,dna_id) values('2020-11-05',50000,14);
insert into donate_details(donate_date,money,dna_id) values('2020-11-12',50000,14);

insert into donator_notification(project_image,create_time,read,handled,title,message,topic,total_money,project_id,dnt_id) values ('https://baotuyenquang.com.vn/media/images/2018/04/img_20180404092429.jpg','2021-05-13 20:50:40.075187',false,false,'Xử lý tiền dự án quá hạn','Testing hạn xử lý đã quá 7 ngày...','closed',80000,8,1);
insert into donator_notification(project_image,create_time,read,handled,title,message,topic,total_money,project_id,dnt_id) values ('https://photo-cms-giaoduc.zadn.vn/w700/Uploaded/2021/juznus/2020_10_21/gdvn-truonghocsaulu7-giaoduc-net-vn-3067.jpg','2021-09-13 20:50:40.075187',false,false,'Xử lý tiền dự án quá hạn','Testing hạn xử lý chưa quá 7 ngày...','closed',40000,12,1);

insert into push_notification(topic,title,message) values('new','Dự án từ thiện mới','Có một chương trình từ thiện mới, nếu bạn quan tâm hãy ghé thăm hoàn cảnh này');
insert into push_notification(topic,title,message) values('overdue','Dự án đã quá hạn','Dự án cộng đồng mà bạn đã tham gia quyên góp thật không may đã bị thất bại do quá hạn quyên góp. Hãy xem thông báo để cập nhật tình hình mới nhất.');
insert into push_notification(topic,title,message) values('closed','Xử lý tiền dự án quá hạn','Dự án cộng đồng mà bạn đã tham gia quyên góp đã bị đóng vì đã quá hạn. Nhấn để thực hiện việc chuyển tiền sang dự án khác hoặc sau 7 ngày tất cả số tiền bạn đã ủng hộ cho dự án này sẽ được chuyển vào quỹ chung của Chari');
insert into push_notification(topic,title,message) values('extended','Dự án đã được gia hạn','Dự án cộng đồng mà bạn đã tham gia quyên góp đã được gia hạn thêm thời gian. Hãy kêu gọi bạn bè ủng hộ cho dự án.');
insert into push_notification(topic,title,message) values('reached','Chương trình thành công','Cám ơn bạn đã đồng hành cùng chương trình này, chương trình đã quyên góp thành công và sẽ được tiến hành thi công. Những bài viết liên quan đến chương trình này sẽ được gửi đến bạn.');

insert into post(name,content,project_id,clb_id,image_url,video_url,is_public,public_time) values ('Dự án hỗ trợ cặp phao cho các em học sinh ở vùng cao Ba Vì đã thành công'
,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 10000 cặp phao cho trẻ em vùng cao Ba Vì tỉnh Quảng Ngãi, giúp các em yên tâm hơn khi mùa lũ lụt sắp về.'
,5,0,'https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg'
,'https://firebasestorage.googleapis.com/v0/b/chari-9ed04.appspot.com/o/project005.mp1?alt=media&token=b7e2d9cf-3240-42b7-b4ef-1985f252a34a',true,'2021-05-13 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',1);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',1);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',1);
insert into post_images(image_url,pos_id) values('https://anh.eva.vn//upload/3-2015/images/2015-09-08/1441684268-11992496_1627825204133394_783327606_n.jpg',1);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/09/kinh-so-canh-hang-tram-nguoi-dan-lieu-minh-du-day-cap-vuot-suoi.jpg',1);
insert into post_images(image_url,pos_id) values('https://anh.24h.com.vn/upload/4-2014/images/2014-11-30/1417327823-vuot-suoi-den-truong-1.jpg',1);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án bữa cơm từ thiện: Ủng hộ 400 phần cơm cho bệnh nhân bệnh viện 115 quận 10 sắp đạt chỉ tiêu'
,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi được 80% tiền quyên góp. Hãy tiếp tục kêu gọi mọi người tham gia để giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
,10,1,'https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg'
,true,'2021-04-13 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',2);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',2);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',2);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',2);


insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án bữa cơm từ thiện: Ủng hộ 400 phần cơm cho bệnh nhân bệnh viện 115 quận 10 đã thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,10,1,'https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg'
                                                                                        ,true,'2021-04-13 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',3);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',3);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',3);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',3);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án tài trợ xe lăn cho người khuyết tật sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,3,1,'https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg'
                                                                                        ,true,'2021-04-03 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',4);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',4);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',4);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',4);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án hỗ trợ vốn sinh kế cho người dân Tây Ninh sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,4,1,'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG'
                                                                                        ,true,'2021-04-01 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',5);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',5);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',5);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',5);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án hỗ trợ vốn sinh kế cho người dân Tây Ninh sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,3,1,'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG'
                                                                                        ,true,'2021-04-01 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',6);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',6);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',6);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',6);


insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án hỗ trợ vốn sinh kế cho người dân Tây Ninh sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,3,1,'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG'
                                                                                        ,true,'2021-04-01 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',7);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',7);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',7);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',7);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án hỗ trợ vốn sinh kế cho người dân Tây Ninh sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,3,2,'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG'
                                                                                        ,true,'2021-04-01 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',8);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',8);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',8);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',8);

insert into post(name,content,project_id,clb_id,image_url,is_public,public_time) values ('Dự án hỗ trợ vốn sinh kế cho người dân Tây Ninh sắp thành công'
                                                                                        ,'Với sự ủng hộ của những nhà hảo tâm Chari đã quyên gọi vốn thành công và đã tiến hành giải ngân cho người thụ hưởng của dự án. Dự án đã đem về hơn 400 phần cơm cho bệnh nhân bệnh viên 115 quận 10, giúp những bệnh nhân ở đây được bữa cơm no ấm lòng.'
                                                                                        ,4,2,'https://baotayninh.vn/image/fckeditor/upload/2018/20181204/images/trao%20von.JPG'
                                                                                        ,true,'2021-04-01 20:50:40.075187');
insert into post_images(image_url,pos_id) values('https://nhandan.vn/imgold/media/k2/items/src/3764/e23c2235804f01fe0099318e62cdbc73.jpg',9);
insert into post_images(image_url,pos_id) values('https://tamnguyenviet.vn/wp-content/uploads/2020/10/t%E1%BA%B7ng-phao-B%E1%BA%AFc-B%C3%ACnh-B%C3%ACnh-Thu%E1%BA%ADn.jpg',9);
insert into post_images(image_url,pos_id) values('https://mb.dkn.tv/wp-content/uploads/2015/10/tre-em-mien-nui-den-truong-42.jpg',9);
insert into post_images(image_url,pos_id) values('https://danviet.mediacdn.vn/upload/4-2014/images/2014-10-07/1434400197-134650-2.jpg',9);
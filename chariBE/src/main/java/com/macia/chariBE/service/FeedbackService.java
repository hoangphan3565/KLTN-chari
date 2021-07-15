package com.macia.chariBE.service;

import com.macia.chariBE.model.DonatorNotification;
import com.macia.chariBE.model.Feedback;
import com.macia.chariBE.model.JwtUser;
import com.macia.chariBE.pushnotification.NotificationObject;
import com.macia.chariBE.pushnotification.PushNotificationService;
import com.macia.chariBE.repository.IDonatorRepository;
import com.macia.chariBE.repository.IFeedbackRepository;
import com.macia.chariBE.repository.IJwtUserRepository;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Service
public class FeedbackService {
    @PersistenceContext
    private EntityManager em;

    @Autowired
    private IFeedbackRepository repo;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private DonatorNotificationService donatorNotificationService;

    @Autowired
    private IJwtUserRepository jwtUserRepo;

    @Autowired
    private IDonatorRepository donatorRepo;

    public void save(Feedback Feedback) {
        repo.saveAndFlush(Feedback);
    }

    public JSONObject deleteById(Integer id){
        JSONObject jso = new JSONObject();
        if(repo.findById(id).isPresent()){
            this.repo.deleteById(id);
            jso.put("errorCode",0);
            jso.put("message","Xoá tin tức thành công!");
        }else{
            jso.put("errorCode",1);
            jso.put("message","Tin đã bị xoá trước đó!");
        }
        return jso;
    }

    public List<Feedback> findAll(){return repo.findAll();}

    public JSONObject replyFeedback(Feedback fk){
        JSONObject jso = new JSONObject();
        if(repo.findById(fk.getFEB_ID()).isPresent()){
            if(!repo.findById(fk.getFEB_ID()).orElseThrow().getIsReply()){
                JwtUser appUser = jwtUserRepo.findByUsername(fk.getUsername());
                if(appUser!=null){
                    if(appUser.getFcmToken()!=null){
                        pushNotificationService.sendMessageToToken(NotificationObject.builder()
                                .message(fk.getTheReply()).title("Trả lời cho ý kiến "+fk.getTitle()).token(appUser.getFcmToken()).build());
                    }
                    else{
                        donatorNotificationService.save(DonatorNotification.builder()
                                .title("Trả lời cho ý kiến "+fk.getTitle()).message(fk.getTheReply())
                                .read(false).handled(false).donator(donatorRepo.findByUsername(fk.getUsername()))
                                .project_image("https://firebasestorage.googleapis.com/v0/b/chari-c3f85.appspot.com/o/resource%2Fok.png?alt=media&token=4cda8faa-15d1-4265-9ece-d39ea43337e1").build());
                        fk.setIsReply(true);
                        repo.saveAndFlush(fk);
                        jso.put("errorCode",0);
                        jso.put("message","Trả lời phản hồi thành công thành công!");
                    }
                }else{
                    jso.put("errorCode", 1);
                    jso.put("message", "Không thể tìm thấy người dùng với username: "+fk.getUsername()+ " !");
                }
            }else{
                jso.put("errorCode", 0);
                jso.put("message", "Feedback đã được trả lời trước đó!");
            }

        }else{
            jso.put("errorCode",0);
            jso.put("message","Phản hồi này đã bị xoá trước đó!");
        }
        return jso;
    }


    public int countAll() {
        try {
            TypedQuery<Feedback> query = em.createNamedQuery("named.feedback.findAll", Feedback.class);
            return query.getResultList().size();
        } catch (NoResultException e) {
            return -1;
        }
    }

    public List<Feedback> findPageASizeB(int a,int b) {
        try {
            TypedQuery<Feedback> query = em.createNamedQuery("named.feedback.findAll", Feedback.class)
                    .setFirstResult(a*b).setMaxResults(b);
            return query.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
}

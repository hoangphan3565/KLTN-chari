package com.macia.chariBE.controller;

import com.macia.chariBE.DTO.ProjectDTO;
import com.macia.chariBE.model.*;
import com.macia.chariBE.repository.IPushNotificationRepository;
import com.macia.chariBE.service.*;
import com.macia.chariBE.utility.ENotificationTopic;
import com.macia.chariBE.utility.EProjectStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/projects")
public class ProjectController {
    @Autowired
    private ProjectService projectService;

    @Autowired
    private IPushNotificationRepository pushNotificationRepository;

    @Autowired
    private DonatorNotificationService donatorNotificationService;


//    @GetMapping()
//    public ResponseEntity<?> getAllProject() {
//        return ResponseEntity.ok().body(projectService.getProjectDTOs());
//    }

    @DeleteMapping("/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> deleteProjectByID(@PathVariable(value = "id") Integer id,
                                               @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.deleteProjectByID(id,clb_id));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getProjectByID(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.getProjectDTOById(id));
    }

    @PutMapping("/handle_all_money")
    public void handleAllCloseAndUnHandled() {
        donatorNotificationService.handleAllMoneyOfClosedProjectOverSevenDay();
    }

    // Services for admin
    @GetMapping("/count")
    public ResponseEntity<?> countAllProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereUncloseAndVerified());
    }
    @GetMapping("/page/{a}/size/{b}")
    public ResponseEntity<?> getProjectDTOsPageASizeB(@PathVariable(value = "a") Integer a,
                                                    @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getProjectDTOsWhereUncloseAndVerifiedPageASizeB(a-1,b));
    }
    @GetMapping("/unverified/count")
    public ResponseEntity<?> countUnverifiedProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereUnverified());
    }
    @GetMapping("/unverified/page/{a}/size/{b}")
    public ResponseEntity<?> getUnverifiedProject(@PathVariable(value = "a") Integer a,
                                                  @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getUnverifiedProjects(a-1,b));
    }
    @GetMapping("/closed/count")
    public ResponseEntity<?> countClosedProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereClosed());
    }
    @GetMapping("/closed/page/{a}/size/{b}")
    public ResponseEntity<?> getClosedProjectDTO(@PathVariable(value = "a") Integer a,
                                                 @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getClosedProjects(a-1,b));
    }

    @GetMapping("/activating/count")
    public ResponseEntity<?> countActivatingProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereActivating());
    }
    @GetMapping("/activating/page/{a}/size/{b}")
    public ResponseEntity<?> getActivatingProjectDTO(@PathVariable(value = "a") Integer a,
                                                     @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getActivatingProjectDTOs(a-1,b));
    }

    @GetMapping("/reached/count")
    public ResponseEntity<?> countReachedProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereReached());
    }
    @GetMapping("/reached/page/{a}/size/{b}")
    public ResponseEntity<?> getReachedProjectDTO(@PathVariable(value = "a") Integer a,
                                                  @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getReachedProjectDTOs(a-1,b));
    }

    @GetMapping("/overdue/count")
    public ResponseEntity<?> countOverdueProject() {
        return ResponseEntity.ok().body(projectService.countAllWhereOverdue());
    }
    @GetMapping("/overdue/page/{a}/size/{b}")
    public ResponseEntity<?> getOverdueProjectDTO(@PathVariable(value = "a") Integer a,
                                                  @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getOverdueProjectDTOs(a-1,b));
    }


    //for collaborator
    @GetMapping("/collaborator/{clb_id}/count")
    public ResponseEntity<?> countAllProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.countAllUnverifiedByCollaboratorId(clb_id));
    }
    @GetMapping("/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getAllProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id,
                                                              @PathVariable(value = "a") Integer a,
                                                              @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getUnverifiedProjectDTOsByCollaboratorIdPageASizeB(clb_id,a-1,b));
    }

    @GetMapping("/activating/collaborator/{clb_id}/count")
    public ResponseEntity<?> countActivatingProjectByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.countAllWhereActivatingByCollaboratorId(clb_id));
    }
    @GetMapping("/activating/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getActivatingProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id,
                                                                     @PathVariable(value = "a") Integer a,
                                                                     @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getActivatingProjectDTOsByCollaboratorId(clb_id,a-1,b));
    }
    @GetMapping("/reached/collaborator/{clb_id}/count")
    public ResponseEntity<?> countReachedProjectByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.countAllWhereReachedByCollaboratorId(clb_id));
    }
    @GetMapping("/reached/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getReachedProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id,
                                                                  @PathVariable(value = "a") Integer a,
                                                                  @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getReachedProjectDTOsByCollaboratorId(clb_id,a-1,b));
    }

    @GetMapping("/overdue/collaborator/{clb_id}/count")
    public ResponseEntity<?> countOverdueProjectByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.countAllWhereOverdueByCollaboratorId(clb_id));
    }
    @GetMapping("/overdue/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getOverdueProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id,
                                                                  @PathVariable(value = "a") Integer a,
                                                                  @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getOverdueProjectDTOsByCollaboratorId(clb_id,a-1,b));
    }


    @GetMapping("/closed/collaborator/{clb_id}/count")
    public ResponseEntity<?> countClosedProjectByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.countCloseByCollaboratorId(clb_id));
    }
    @GetMapping("/closed/collaborator/{clb_id}/page/{a}/size/{b}")
    public ResponseEntity<?> getClosedProjectDTOByCollaboratorId(@PathVariable(value = "clb_id") Integer clb_id,
                                                                 @PathVariable(value = "a") Integer a,
                                                                 @PathVariable(value = "b") Integer b) {
        return ResponseEntity.ok().body(projectService.getClosedProjectsOfCollaborator(clb_id,a-1,b));
    }
    //end - for collaborator


    @GetMapping("/ready_to_move_money/{money}")
    public ResponseEntity<?> getProjectReadyToMoveMoney(@PathVariable(value = "money") Integer money) {
        return ResponseEntity.ok().body(projectService.getProjectReadyToMoveMoney(money));
    }

    @PutMapping("/approve/{id}")
    public ResponseEntity<?> approveProject(@PathVariable(value = "id") Integer id) {
        return ResponseEntity.ok().body(projectService.approveProject(id));
    }

    @PutMapping("/close/{id}/collaborator/{clb_id}")
    public ResponseEntity<?> closeProject(@PathVariable(value = "id") Integer id,
                                          @PathVariable(value = "clb_id") Integer clb_id) {
        PushNotification pn = this.pushNotificationRepository.findByTopic(ENotificationTopic.CLOSED);
        if(!projectService.findProjectById(id).getProjectType().getCanDisburseWhenOverdue()){
            donatorNotificationService.saveAndPushNotificationToUser(pn,id);
        }
        return ResponseEntity.ok().body(projectService.closeProject(id,clb_id));
    }


    @PutMapping("/extend/{id}/num_of_date/{nod}")
    public ResponseEntity<?> extendProjectDeadline(
            @PathVariable(value = "id") Integer id,
            @PathVariable(value = "nod") Integer nod) {
        PushNotification pn = this.pushNotificationRepository.findByTopic(ENotificationTopic.EXTENDED);
        donatorNotificationService.saveAndPushNotificationToUser(pn,id);
        return ResponseEntity.ok().body(projectService.extendProject(id,nod));
    }

    @PostMapping("/create/collaborator/{clb_id}")
    public ResponseEntity<?> create(
            @RequestBody ProjectDTO project,
            @PathVariable(value = "clb_id") Integer clb_id) {
        return ResponseEntity.ok().body(projectService.createProject(project,clb_id));
    }

    @PutMapping("/update")
    public ResponseEntity<?> update(@RequestBody ProjectDTO project) {
        return ResponseEntity.ok().body(projectService.updateProject(project));
    }
    @PutMapping("/update_and_approve")
    public ResponseEntity<?> updateAndApprove(@RequestBody ProjectDTO project) {
        return ResponseEntity.ok().body(projectService.updateAndApprove(project));
    }

    //============================== Find =================================//
    @GetMapping("/find/{key}")
    public ResponseEntity<?> getProjectDTOsUncloseAndVerifiedByName(@PathVariable(value = "key") String key) {
        return ResponseEntity.ok().body(projectService.getProjectDTOsUncloseAndVerifiedByName(key));
    }



    // ============================== Filter =================================//
    @GetMapping("/filter/favorite/donator/{did}/city/{c_ids}/project_type/{pt_ids}/status/{st}/find/{key}/page/{p}/size/{s}")
    public ResponseEntity<?> getProjectsByMultiFilterAndSearchKey(
            @PathVariable(value = "did") String did, @PathVariable(value = "c_ids") List<String> c_ids, @PathVariable(value = "pt_ids") List<String> pt_ids,
            @PathVariable(value = "st") List<String> status, @PathVariable(value = "key") String key, @PathVariable(value = "p") Integer p, @PathVariable(value = "s") Integer s) {
        return ResponseEntity.ok().body(projectService.getProjectsByMultiFilterAndSearchKey(did,c_ids,pt_ids,status,key,p-1,s));
    }

    @GetMapping("/filter/favorite/donator/{did}/city/{c_ids}/project_type/{pt_ids}/status/{st}/find/{key}/count")
    public ResponseEntity<?> countTotalProjectsByMultiFilterAndSearchKey(
            @PathVariable(value = "did") String did, @PathVariable(value = "c_ids") List<String> c_ids, @PathVariable(value = "pt_ids") List<String> pt_ids,
            @PathVariable(value = "st") List<String> status, @PathVariable(value = "key") String key){
        return ResponseEntity.ok().body(projectService.countTotalProjectsByMultiFilterAndSearchKey(did,c_ids,pt_ids,status,key));
    }

    // update project donate status
    @GetMapping("/update_donate_status")
    public ResponseEntity<?> getProjectDTOsUncloseAndVerifiedByName() {
        projectService.updateAllProjectStatus();
        return ResponseEntity.ok().body("Cập nhật trạng thái thành công");
    }

}

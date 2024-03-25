class GroupThreadMessage {
  List<gpThreads>? GpThreads;
  List<dynamic>? GpThreadStar;
  List<mUsers>? MUsers;
  GroupThreadMessage({this.GpThreads,this.GpThreadStar,});

  GroupThreadMessage.fromJson(Map<String, dynamic> json) {

    if (json['retrieveGroupThread']['t_group_threads'] != null) {
      GpThreads = <gpThreads>[];
      json['retrieveGroupThread']['t_group_threads'].forEach((v) {
        GpThreads!.add(new gpThreads.fromJson(v));
      });
    } 
    if(json['retrievehome']['m_users'] != null){
      MUsers = <mUsers>[];
      json['retrievehome']['m_users'].forEach((v){
        MUsers!.add(new mUsers.fromJson(v));
      });
    }
     GpThreadStar = json['retrieveGroupThread']['t_group_star_thread_msgids'];


  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.GpThreads != null) {
      data['retrieveGroupThread']['t_group_threads'] =
          this.GpThreads!.map((e) => e.toJson()).toList();
    }
    if(this.MUsers != null){
      data['retrievehome']['m_users'] = this.MUsers!.map((e) => e.toJson()).toList();
    }
     data['retrieveGroupThread']['t_group_star_thread_msgids']= this.GpThreadStar;
    return data;
  }
}
class mUsers {
  String? name;
  String? email;
  mUsers({this.email,this.name});
  mUsers.fromJson(Map<String,dynamic> json){
    
    name  = json ['name'];
    email = json ['email'];
   }
   Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data ['name'] = this.name;
    data['email'] = this.email;
    return data;
   }

}


class gpThreads {
  int? id;
  String? name;
  String? groupthreadmsg;
  String? created_at;
   gpThreads({
     this.id,
     this.groupthreadmsg,
     this.name,
     this.created_at
  });
   gpThreads.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name  = json ['name'];
    groupthreadmsg = json['groupthreadmsg'];
    created_at  = json ['created_at'];
   }
   Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['created_at'] = this.created_at;
    data['groupthreadmsg'] = this.groupthreadmsg;
    data ['name'] = this.name;
    data['id'] = this.id;
    return data;
   }
}
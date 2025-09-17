class Company {
  Company({required this.data});

  final Data? data;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  Data({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.idx,
    required this.docstatus,
    required this.compName,
    required this.compAddress,
    required this.adressLine2,
    required this.compPhone,
    required this.compPincode,
    required this.website,
    required this.stateCode,
    required this.defaultComp,
    required this.compMobile,
    required this.compEmail,
    required this.compContact,
    required this.compGstin,
    required this.fy,
    required this.ourBank,
    required this.acName,
    required this.acNo,
    required this.bBranch,
    required this.ifscCode,
    required this.doctype,
  });

  final String? name;
  final String? owner;
  final DateTime? creation;
  final DateTime? modified;
  final String? modifiedBy;
  final int? idx;
  final int? docstatus;
  final String? compName;
  final String? compAddress;
  final String? adressLine2;
  final String? compPhone;
  final String? compPincode;
  final String? website;
  final String? stateCode;
  final int? defaultComp;
  final String? compMobile;
  final String? compEmail;
  final String? compContact;
  final String? compGstin;
  final String? fy;
  final String? ourBank;
  final String? acName;
  final String? acNo;
  final String? bBranch;
  final String? ifscCode;
  final String? doctype;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json["name"],
      owner: json["owner"],
      creation: DateTime.tryParse(json["creation"] ?? ""),
      modified: DateTime.tryParse(json["modified"] ?? ""),
      modifiedBy: json["modified_by"],
      idx: json["idx"],
      docstatus: json["docstatus"],
      compName: json["comp_name"],
      compAddress: json["comp_address"],
      adressLine2: json["adress_line2"],
      compPhone: json["comp_phone"],
      compPincode: json["comp_pincode"],
      website: json["website"],
      stateCode: json["state_code"],
      defaultComp: json["default_comp"],
      compMobile: json["comp_mobile"],
      compEmail: json["comp_email"],
      compContact: json["comp_contact"],
      compGstin: json["comp_gstin"],
      fy: json["fy"],
      ourBank: json["our_bank"],
      acName: json["ac_name"],
      acNo: json["ac_no"],
      bBranch: json["b_branch"],
      ifscCode: json["ifsc_code"],
      doctype: json["doctype"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation?.toIso8601String(),
    "modified": modified?.toIso8601String(),
    "modified_by": modifiedBy,
    "idx": idx,
    "docstatus": docstatus,
    "comp_name": compName,
    "comp_address": compAddress,
    "adress_line2": adressLine2,
    "comp_phone": compPhone,
    "comp_pincode": compPincode,
    "website": website,
    "state_code": stateCode,
    "default_comp": defaultComp,
    "comp_mobile": compMobile,
    "comp_email": compEmail,
    "comp_contact": compContact,
    "comp_gstin": compGstin,
    "fy": fy,
    "our_bank": ourBank,
    "ac_name": acName,
    "ac_no": acNo,
    "b_branch": bBranch,
    "ifsc_code": ifscCode,
    "doctype": doctype,
  };
}

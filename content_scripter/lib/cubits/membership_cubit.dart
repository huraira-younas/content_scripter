import 'package:content_scripter/models/membership_model/exports.dart';
import 'package:content_scripter/models/feature_model.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:content_scripter/services/api_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

class MembershipCubit extends Cubit<MembershipState> {
  MembershipCubit() : super(MembershipState()) {
    getAllMemberships();
  }

  List<MembershipTimePeriod> _periods = [];
  List<MembershipModel> _memberships = [];
  FeatureModel? _feature;

  FeatureModel? get feature => _feature;
  List<MembershipModel> get memberships => _memberships;
  MembershipModel get freeMembership => _memberships.firstWhere(
        (e) => e.price == 0,
      );

  MembershipModel getMembership(String memId) => _memberships.firstWhere(
        (e) => e.id == memId,
      );

  Future<void> getAllMemberships({
    bool isRefresh = false,
    bool shouldEmit = true,
  }) async {
    try {
      if (state.loading || (!isRefresh && _memberships.isNotEmpty)) {
        return;
      }

      _emit(loading: !isRefresh);

      final response = await Future.wait([
        ApiService.sendGetRequest(ApiRoutes.getAllMemberships),
        ApiService.sendGetRequest(ApiRoutes.getMembershipPeriod),
      ]);

      if (response.any((e) => e['status'] != 200)) {
        throw "Couldn't get membership";
      }

      final list = jsonDecode(response[1]['body']) as List<dynamic>;
      final body = jsonDecode(response[0]['body']) as List<dynamic>;

      _periods = list.map((e) => MembershipTimePeriod.fromJson(e)).toList();
      _memberships = body.map((e) => MembershipModel.fromJson(e)).toList();
      _memberships.sort((a, b) => a.price.compareTo(b.price));

      if (shouldEmit) {
        _emit();
      }
    } catch (e) {
      _emit(
        error: MembershipError(
          title: "Error",
          message: e.toString(),
          type: isRefresh ? MemErrorType.normal : MemErrorType.brute,
        ),
      );
    }
  }

  Future<void> getFeature(String email) async {
    try {
      if (memberships.isEmpty) {
        getAllMemberships(shouldEmit: false);
      } else {
        _emit(loading: true);
      }

      log("Fetching features");
      final response = await ApiService.sendRequest(
        ApiRoutes.getFeature,
        {"email": email},
      );
      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      _feature = FeatureModel.fromJson(body['feature']);
      log(feature.toString());
      _emit();
    } catch (e) {
      log(e.toString());
      _emit(
        error: MembershipError(
          title: "Error",
          message: e.toString(),
        ),
      );
    }
  }

  void updateFeature(FeatureModel newFeature) {
    _feature = newFeature;
    _emit();
  }

  Future<void> purchaseMembership({
    String type = "subscription",
    required double taxAndFees,
    String mode = "GooglePay",
    required String userId,
    required String memId,
    required String trxId,
    required int period,
  }) async {
    try {
      final isSubs = type == "subscription";
      log("Mode: $mode, isSubs: $isSubs");
      _emit(
        loading: true,
        action: isSubs ? MembershipAction.purchase : MembershipAction.upgrade,
      );

      final response = await ApiService.sendRequest(ApiRoutes.purchasePlan, {
        "membershipPlanId": memId,
        "taxAndFees": taxAndFees,
        "transactionId": trxId,
        "paymentMode": mode,
        "userId": userId,
        "period": period,
        "planType": type,
      });

      log(response.toString());
      if (response['status'] != 200) throw "Error Purchasing Plan";

      _emit(action: MembershipAction.purchase);
    } catch (e) {
      log(e.toString());
      _emit(
        error: MembershipError(
          type: MemErrorType.normal,
          message: e.toString(),
          title: "Error",
        ),
      );
    }
  }

  Future<void> cancelMembership({required String userId}) async {
    try {
      _emit(loading: true, action: MembershipAction.cancel);
      final response = await ApiService.sendRequest(ApiRoutes.cancelPlan, {
        "userId": userId,
      });

      if (response['status'] != 200) throw "Error Cancelling Plan";
      _emit(action: MembershipAction.cancel);
    } catch (e) {
      log(e.toString());
      _emit(
        error: MembershipError(
          type: MemErrorType.normal,
          message: e.toString(),
          title: "Error",
        ),
      );
    }
  }

  void _emit({
    MembershipAction action = MembershipAction.none,
    MembershipError? error,
    bool loading = false,
  }) {
    emit(MembershipState(
      memberships: _memberships,
      periods: _periods,
      feature: _feature,
      loading: loading,
      action: action,
      error: error,
    ));
  }
}

enum MembershipAction { purchase, upgrade, cancel, none }

final class MembershipState {
  final List<MembershipTimePeriod> periods;
  final List<MembershipModel> memberships;
  final MembershipAction action;
  final MembershipError? error;
  final FeatureModel? feature;
  final bool loading;

  MembershipState({
    this.action = MembershipAction.none,
    this.memberships = const [],
    this.periods = const [],
    this.loading = false,
    this.feature,
    this.error,
  });
}

enum MemErrorType { brute, normal }

final class MembershipError {
  final MemErrorType type;
  final String message;
  final String title;

  MembershipError({
    this.type = MemErrorType.brute,
    required this.message,
    required this.title,
  });
}

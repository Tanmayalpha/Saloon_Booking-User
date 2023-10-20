import 'package:beauty_salons_customer/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/global_service.dart';

class BookingsController extends GetxController {
  BookingRepository _bookingsRepository;

  final bookings = <Booking>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  ScrollController scrollController;

  BookingsController() {
    _bookingsRepository = new BookingRepository();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.find<AuthService>().isAuth){
      getBookingStatuses();
    }

  }

  Future refreshBookings({bool showMessage = false, String statusId}) async {
    changeTab(statusId);
    if (showMessage&&Get.find<AuthService>().isAuth) {

      await getBookingStatuses();
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "Bookings page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isDone.value) {
        loadBookingsOfStatus(statusId: currentStatus.value);
      }
    });
  }

  void changeTab(String statusId) async {
    this.bookings.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future getBookingStatuses() async {
    List<BookingStatus> _bookings = [];
    _bookings = await _bookingsRepository.getStatuses();
    bookingStatuses.assignAll(_bookings);
    currentStatus.value = bookingStatuses[0].id;
    loadBookingsOfStatus(statusId: currentStatus.value);
    /*try {

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }*/
  }

  BookingStatus getStatusByOrder(int order) =>
      bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
       // Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookingsOfStatus({String statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      //page.value++;
      List<Booking> _bookings = [];
      if (bookingStatuses.isNotEmpty) {
        _bookings = await _bookingsRepository.all(statusId, page: page.value);
      }
      isLoading.value = false;
      bookings.clear();
      if (_bookings.isNotEmpty) {
        bookings.addAll(_bookings);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;

      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBookingService(Booking booking) async {
    try {
      if (booking.status.order <
          Get.find<GlobalService>().global.value.onTheWay) {
        final _status =
            getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking =
            new Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
      }
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }    }
  }
}

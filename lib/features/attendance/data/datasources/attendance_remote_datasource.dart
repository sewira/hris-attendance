// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import '../../../../config/endpoints/api_endpoints.dart';
// import '../../../../core/error/failure.dart';
// import '../../../../core/network/dio_client.dart';
// import '../../domain/repositories/attendance_repository.dart';
// import '../models/attendance_model.dart';

// class AttendanceRemoteDatasource implements AttendanceRepository {
//   final Dio _dio = DioClient.instance.dio;

//   @override
//   Future<Either<Failure, AttendanceModel>> clockIn(String employeeId) async {
//     try {
//       final response = await _dio.post(
//         ApiEndpoints.clockIn,
//         data: {'employee_id': employeeId},
//       );
//       return Right(AttendanceModel.fromJson(response.data));
//     } on DioException catch (e) {
//       return Left(ServerFailure(e.message ?? 'Server error'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, AttendanceModel>> clockOut(String employeeId) async {
//     try {
//       final response = await _dio.post(
//         ApiEndpoints.clockOut,
//         data: {'employee_id': employeeId},
//       );
//       return Right(AttendanceModel.fromJson(response.data));
//     } on DioException catch (e) {
//       return Left(ServerFailure(e.message ?? 'Server error'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, AttendanceModel?>> getTodayAttendance(
//       String employeeId) async {
//     try {
//       final response = await _dio.get(
//         ApiEndpoints.todayAttendance,
//         queryParameters: {'employee_id': employeeId},
//       );
//       if (response.data == null) return const Right(null);
//       return Right(AttendanceModel.fromJson(response.data));
//     } on DioException catch (e) {
//       return Left(ServerFailure(e.message ?? 'Server error'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<AttendanceModel>>> getAttendanceHistory(
//       String employeeId) async {
//     try {
//       final response = await _dio.get(
//         ApiEndpoints.attendanceHistory,
//         queryParameters: {'employee_id': employeeId},
//       );
//       final List<dynamic> data = response.data;
//       return Right(data.map((json) => AttendanceModel.fromJson(json)).toList());
//     } on DioException catch (e) {
//       return Left(ServerFailure(e.message ?? 'Server error'));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }

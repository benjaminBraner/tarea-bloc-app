// lib/bloc/order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/order_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final String apiUrl = 'https://674869495801f5153590c2a3.mockapi.io/api/v1/order';

  OrderBloc() : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrder>(_onUpdateOrder);
    on<DeleteOrder>(_onDeleteOrder);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final orders = jsonList.map((json) => Order.fromJson(json)).toList();
        emit(OrderLoaded(orders));
      } else {
        emit(OrderError('Error al cargar órdenes'));
      }
    } catch (e) {
      emit(OrderError('Error de conexión'));
    }
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      emit(OrderLoading());
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(event.order.toJson()),
        );

        if (response.statusCode == 201) {
          final newOrder = Order.fromJson(json.decode(response.body));
          final updatedOrders = List<Order>.from(currentState.orders)..add(newOrder);
          emit(OrderLoaded(updatedOrders));
        } else {
          emit(OrderError('Error al crear orden'));
        }
      } catch (e) {
        emit(OrderError('Error de conexión'));
      }
    }
  }

  Future<void> _onUpdateOrder(UpdateOrder event, Emitter<OrderState> emit) async {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      emit(OrderLoading());
      try {
        final response = await http.put(
          Uri.parse('$apiUrl/${event.order.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(event.order.toJson()),
        );

        if (response.statusCode == 200) {
          final updatedOrders = currentState.orders.map((order) {
            return order.id == event.order.id ? event.order : order;
          }).toList();
          emit(OrderLoaded(updatedOrders));
        } else {
          emit(OrderError('Error al actualizar orden'));
        }
      } catch (e) {
        emit(OrderError('Error de conexión'));
      }
    }
  }

  Future<void> _onDeleteOrder(DeleteOrder event, Emitter<OrderState> emit) async {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      emit(OrderLoading());
      try {
        final response = await http.delete(Uri.parse('$apiUrl/${event.orderId}'));

        if (response.statusCode == 200) {
          final updatedOrders = currentState.orders
              .where((order) => order.id != event.orderId)
              .toList();
          emit(OrderLoaded(updatedOrders));
        } else {
          emit(OrderError('Error al eliminar orden'));
        }
      } catch (e) {
        emit(OrderError('Error de conexión'));
      }
    }
  }
}
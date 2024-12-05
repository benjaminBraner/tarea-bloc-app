// lib/screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../models/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _amountController = TextEditingController();
  Order? _editingOrder;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrders());
  }

  void _showOrderDialog({Order? order}) {
    _nameController.text = order?.name ?? '';
    _emailController.text = order?.email ?? '';
    _amountController.text = order?.totalAmount.toString() ?? '';
    _editingOrder = order;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(order == null ? 'Crear Orden' : 'Editar Orden'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nombre'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Correo'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Monto Total'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newOrder = Order(
                  id: _editingOrder?.id,
                  name: _nameController.text,
                  email: _emailController.text,
                  totalAmount: double.parse(_amountController.text),
                  avatar: 'https://via.placeholder.com/150',
                  status: true,
                  date: DateTime.now().millisecondsSinceEpoch,
                );

                if (_editingOrder == null) {
                  context.read<OrderBloc>().add(CreateOrder(newOrder));
                } else {
                  context.read<OrderBloc>().add(UpdateOrder(newOrder));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Órdenes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showOrderDialog(),
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          } else if (state is OrderLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(order.avatar),
                  ),
                  title: Text(order.name),
                  subtitle: Text('${order.email} - \$${order.totalAmount}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showOrderDialog(order: order),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<OrderBloc>().add(DeleteOrder(order.id!));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay órdenes'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
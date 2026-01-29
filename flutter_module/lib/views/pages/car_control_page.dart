import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/car_control_viewmodel.dart';
import '../shared/section_title.dart';
import '../widgets/header_card.dart';
import '../widgets/car_image_card.dart';
import '../widgets/status_row.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/climate_card.dart';
import '../widgets/seat_card.dart';
import '../widgets/security_card.dart';
import '../widgets/charge_card.dart';

/// 车控主页面
class CarControlPage extends StatelessWidget {
  const CarControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarControlViewModel>(
      builder: (context, viewModel, _) {
        final carModel = viewModel.carModel;
        final statusModel = viewModel.statusModel;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              HeaderCard(
                battery: carModel.battery,
                range: carModel.range,
                lockStatus: carModel.lockStatus,
              ),
              const SizedBox(height: 16),
              const CarImageCard(),
              const SizedBox(height: 16),
              StatusRow(
                vehicleStatus: carModel.status,
                tirePressure: carModel.tirePressure,
                doorStatus: carModel.doorStatus,
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: '快捷控制'),
              const SizedBox(height: 10),
              QuickActionsGrid(
                onUnlock: viewModel.unlockCar,
                onLock: viewModel.lockCar,
                onAirCondition: viewModel.startAirCondition,
                onLights: viewModel.turnOnLights,
                onFuelDoor: viewModel.openFuelDoor,
                onLocate: viewModel.locateCar,
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: '空调'),
              const SizedBox(height: 10),
              ClimateCard(
                targetTemperature: statusModel.targetTemperature,
                climateAuto: statusModel.climateAuto,
                climateDefog: statusModel.climateDefog,
                onTemperatureChanged: viewModel.updateTargetTemperature,
                onAutoPressed: viewModel.toggleClimateAuto,
                onDefogPressed: viewModel.toggleClimateDefog,
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: '座椅'),
              const SizedBox(height: 10),
              SeatCard(
                seatHeatingEnabled: statusModel.seatHeatingEnabled,
                driverSeatHeating: statusModel.driverSeatHeating,
                passengerSeatHeating: statusModel.passengerSeatHeating,
                onHeatingToggled: (_) => viewModel.toggleSeatHeating(),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: '安全'),
              const SizedBox(height: 10),
              SecurityCard(
                doorLockStatus: statusModel.doorLockStatus,
                windowStatus: statusModel.windowStatus,
                trunkStatus: statusModel.trunkStatus,
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: '充电'),
              const SizedBox(height: 10),
              ChargeCard(
                battery: carModel.battery,
                range: carModel.range,
                chargeProgress: statusModel.chargeProgress,
                estimatedTime: statusModel.estimatedTime,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

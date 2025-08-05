import 'package:content_scripter/cubits/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkStatus extends StatelessWidget {
  const NetworkStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetStatus>(
      builder: (context, status) {
        final isMobile = status == InternetStatus.mobile;
        final isWifi = status == InternetStatus.wifi;
        final isVpn = status == InternetStatus.vpn;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            isMobile
                ? Icons.lte_plus_mobiledata
                : isWifi
                    ? Icons.wifi
                    : isVpn
                        ? Icons.vpn_key
                        : Icons.error_outline,
            semanticLabel: "Network Status",
          ),
        );
      },
    );
  }
}

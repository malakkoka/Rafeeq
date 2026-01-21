import 'package:flutter/material.dart';
import 'package:front/color.dart';

class VolunteerActivityScreen extends StatelessWidget {
  const VolunteerActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Activity",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: const [
          /// ================= CURRENT =================
          _SectionTitle("Current Assistance"),

          _CurrentCard(
            title: "Navigation Assistance",
            patientType: "Visually Impaired",
            description:
                "Currently accompanying the patient to the cardiology department.",
            location: "Amman Hospital",
            startedAt: "Started · 9:40 AM",
          ),

          SizedBox(height: 28),

          /// ================= COMPLETED =================
          _SectionTitle("Completed Requests"),

          _HistoryCard(
            title: "Communication Support",
            patientType: "Hearing Impaired",
            description:
                "Translated the conversation between the doctor and the patient using sign language.",
            location: "Amman",
            time: "Jan 22 · 10:30 AM",
            status: HistoryStatus.completed,
          ),

          _HistoryCard(
            title: "Reading Assistance",
            patientType: "Visually Impaired",
            description:
                "Assisted the patient in reading medical reports and prescriptions.",
            location: "Zarqa",
            time: "Jan 21 · 1:00 PM",
            status: HistoryStatus.completed,
          ),

          SizedBox(height: 28),

          /// ================= CANCELLED =================
          _SectionTitle("Cancelled Requests"),

          _HistoryCard(
            title: "Medical Appointment",
            patientType: "Visually Impaired",
            description:
                "The request was cancelled by the patient before the appointment.",
            location: "Zarqa",
            time: "Jan 20 · 3:15 PM",
            status: HistoryStatus.cancelled,
          ),

          SizedBox(height: 28),

          /// ================= EXPIRED =================
          _SectionTitle("Expired Requests"),

          _HistoryCard(
            title: "Navigation Assistance",
            patientType: "Hearing Impaired",
            description:
                "The request expired due to no confirmation from the patient.",
            location: "Irbid",
            time: "Jan 18 · 9:20 AM",
            status: HistoryStatus.expired,
          ),
        ],
      ),
    );
  }
}

/// ================= CURRENT CARD =================

class _CurrentCard extends StatelessWidget {
  final String title;
  final String patientType;
  final String description;
  final String location;
  final String startedAt;

  const _CurrentCard({
    required this.title,
    required this.patientType,
    required this.description,
    required this.location,
    required this.startedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypeIcon(patientType),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const _LiveBadge(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            patientType,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: Colors.redAccent),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 12.5)),
              const Spacer(),
              const Icon(Icons.access_time,
                  size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(
                startedAt,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= HISTORY CARD =================

class _HistoryCard extends StatelessWidget {
  final String title;
  final String patientType;
  final String description;
  final String location;
  final String time;
  final HistoryStatus status;

  const _HistoryCard({
    required this.title,
    required this.patientType,
    required this.description,
    required this.location,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputField,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypeIcon(patientType),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _HistoryStatusBadge(status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            patientType,
            style: const TextStyle(fontSize: 12.5, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: Colors.redAccent),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 12.5)),
              const Spacer(),
              const Icon(Icons.access_time,
                  size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= SMALL WIDGETS =================

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "In Progress",
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
  }
}

enum HistoryStatus { completed, cancelled, expired }

class _HistoryStatusBadge extends StatelessWidget {
  final HistoryStatus status;
  const _HistoryStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String text;

    switch (status) {
      case HistoryStatus.completed:
        color = Colors.green;
        text = "Completed";
        break;
      case HistoryStatus.cancelled:
        color = Colors.red;
        text = "Cancelled";
        break;
      case HistoryStatus.expired:
        color = Colors.orange;
        text = "Expired";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final String patientType;
  const _TypeIcon(this.patientType);

  @override
  Widget build(BuildContext context) {
    final icon = patientType == "Visually Impaired"
        ? Icons.visibility_off
        : Icons.hearing_disabled;

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
      child: Icon(icon, color: AppColors.primaryColor),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

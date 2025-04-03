import 'package:flutter/material.dart';
import 'package:twitter_clone/them/app_theme.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  final bool showBidButton;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.showBidButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysLeft = job.deadline.difference(now).inDays;
    final isExpired = daysLeft < 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildJobTypeIcon(job.category),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          job.category,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textMuted,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(job.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(job.status),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(job.status),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          size: 16,
                          color: AppTheme.secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.budgetRange,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: isExpired
                              ? AppTheme.errorColor
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isExpired ? 'Expired' : 'Due in $daysLeft days',
                          style: TextStyle(
                            fontSize: 13,
                            color: isExpired
                                ? AppTheme.errorColor
                                : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.requiredSkills.map((skill) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (showBidButton) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: job.isOpen && !isExpired ? onTap : null,
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: job.isOpen && !isExpired ? onTap : null,
                        icon: const Icon(Icons.handshake_outlined,
                            size: 18, color: Colors.white),
                        label: const Text('Place Bid',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted ${_getTimeAgo(job.postedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${job.bidsCount} bids',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobTypeIcon(String category) {
    IconData iconData;
    Color color;

    switch (category) {
      case 'Web Development':
        iconData = Icons.web;
        color = Colors.blue;
        break;
      case 'Mobile Development':
        iconData = Icons.smartphone;
        color = Colors.green;
        break;
      case 'UI/UX Design':
      case 'Graphic Design':
        iconData = Icons.brush;
        color = Colors.purple;
        break;
      case 'Content Writing':
      case 'Translation':
        iconData = Icons.article;
        color = Colors.orange;
        break;
      case 'Digital Marketing':
        iconData = Icons.campaign;
        color = Colors.red;
        break;
      case 'Video Editing':
        iconData = Icons.videocam;
        color = Colors.deepOrange;
        break;
      case 'Data Entry':
        iconData = Icons.keyboard;
        color = Colors.teal;
        break;
      case 'Accounting':
        iconData = Icons.account_balance;
        color = Colors.amber;
        break;
      case 'Legal Services':
        iconData = Icons.gavel;
        color = Colors.indigo;
        break;
      case 'Engineering':
        iconData = Icons.build;
        color = Colors.brown;
        break;
      case 'Education & Tutoring':
        iconData = Icons.school;
        color = Colors.cyan;
        break;
      default:
        iconData = Icons.work;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 22,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in-progress':
        return Colors.blue;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      case 'open':
      default:
        return AppTheme.secondaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'in-progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'open':
      default:
        return 'Open';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}

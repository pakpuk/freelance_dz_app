import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_clone/models/bid_model.dart';
import 'package:twitter_clone/models/job_model.dart';
import 'package:twitter_clone/models/user_model.dart';

class LocalStorageService {
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _jobsKey = 'jobs';
  static const String _bidsKey = 'bids';
  static const String _messagesKey = 'messages';
  static const String _lastIdKey = 'last_id';

  // Current user management
  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return UserModel.fromMap(jsonDecode(userJson));
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // User management
  Future<List<UserModel>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson
        .map((json) => UserModel.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersJson = prefs.getStringList(_usersKey) ?? [];

    // Remove existing user if updating
    usersJson.removeWhere(
        (json) => UserModel.fromMap(jsonDecode(json)).id == user.id);

    // Add updated user
    usersJson.add(jsonEncode(user.toMap()));

    await prefs.setStringList(_usersKey, usersJson);
  }

  Future<UserModel?> getUserById(String userId) async {
    final users = await getAllUsers();
    return users.firstWhere((user) => user.id == userId,
        orElse: () => throw Exception('User not found'));
  }

  // Job management
  Future<List<JobModel>> getAllJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final jobsJson = prefs.getStringList(_jobsKey) ?? [];
    return jobsJson.map((json) => JobModel.fromMap(jsonDecode(json))).toList();
  }

  Future<String> saveJob(JobModel job) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jobsJson = prefs.getStringList(_jobsKey) ?? [];

    // Remove existing job if updating
    jobsJson
        .removeWhere((json) => JobModel.fromMap(jsonDecode(json)).id == job.id);

    // Add updated job
    jobsJson.add(jsonEncode(job.toMap()));

    await prefs.setStringList(_jobsKey, jobsJson);
    return job.id;
  }

  Future<JobModel?> getJobById(String jobId) async {
    final jobs = await getAllJobs();
    return jobs.firstWhere((job) => job.id == jobId,
        orElse: () => throw Exception('Job not found'));
  }

  Future<List<JobModel>> getJobsByClientId(String clientId) async {
    final jobs = await getAllJobs();
    return jobs.where((job) => job.clientId == clientId).toList();
  }

  // Bid management
  Future<List<BidModel>> getAllBids() async {
    final prefs = await SharedPreferences.getInstance();
    final bidsJson = prefs.getStringList(_bidsKey) ?? [];
    return bidsJson.map((json) => BidModel.fromMap(jsonDecode(json))).toList();
  }

  Future<String> saveBid(BidModel bid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bidsJson = prefs.getStringList(_bidsKey) ?? [];

    // Remove existing bid if updating
    bidsJson
        .removeWhere((json) => BidModel.fromMap(jsonDecode(json)).id == bid.id);

    // Add updated bid
    bidsJson.add(jsonEncode(bid.toMap()));

    await prefs.setStringList(_bidsKey, bidsJson);
    return bid.id;
  }

  Future<List<BidModel>> getBidsByJobId(String jobId) async {
    final bids = await getAllBids();
    return bids.where((bid) => bid.jobId == jobId).toList();
  }

  Future<List<BidModel>> getBidsByFreelancerId(String freelancerId) async {
    final bids = await getAllBids();
    return bids.where((bid) => bid.freelancerId == freelancerId).toList();
  }

  // Message management placeholder (to be expanded in future)
  Future<void> saveMessage(Map<String, dynamic> message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messagesJson = prefs.getStringList(_messagesKey) ?? [];
    messagesJson.add(jsonEncode(message));
    await prefs.setStringList(_messagesKey, messagesJson);
  }

  // ID generation
  Future<String> generateId(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getInt('${_lastIdKey}_$type') ?? 0;
    final newId = lastId + 1;
    await prefs.setInt('${_lastIdKey}_$type', newId);
    return '$type-$newId';
  }

  // Demo data initialization
  Future<void> initializeDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasData = prefs.getBool('has_demo_data') ?? false;

    if (!hasData) {
      // Create demo users
      final client1 = UserModel.client(
        id: 'client-1',
        name: 'Ahmed Benhamed',
        email: 'ahmed@example.com',
        phone: '+213550000001',
        location: 'Algiers',
        companyName: 'TechSolutions Algeria',
      );

      final client2 = UserModel.client(
        id: 'client-2',
        name: 'Fatima Zohra',
        email: 'fatima@example.com',
        phone: '+213550000002',
        location: 'Oran',
        companyName: 'Digital Marketing DZ',
      );

      final freelancer1 = UserModel.freelancer(
        id: 'freelancer-1',
        name: 'Karim Benzaim',
        email: 'karim@example.com',
        phone: '+213550000003',
        location: 'Constantine',
        skills: ['Web Development', 'Flutter', 'UI/UX Design'],
        hourlyRate: 2000,
        bio: 'Experienced mobile and web developer with 5 years of experience.',
      );

      final freelancer2 = UserModel.freelancer(
        id: 'freelancer-2',
        name: 'Amina Hadj',
        email: 'amina@example.com',
        phone: '+213550000004',
        location: 'Annaba',
        skills: ['Graphic Design', 'Logo Design', 'Branding'],
        hourlyRate: 1800,
        bio: 'Creative graphic designer specializing in brand identity.',
      );

      // Save demo users
      List<String> usersJson = [];
      usersJson.add(jsonEncode(client1.toMap()));
      usersJson.add(jsonEncode(client2.toMap()));
      usersJson.add(jsonEncode(freelancer1.toMap()));
      usersJson.add(jsonEncode(freelancer2.toMap()));

      await prefs.setStringList(_usersKey, usersJson);

      // Create demo jobs
      final now = DateTime.now();

      final job1 = JobModel(
        id: 'job-1',
        title: 'E-commerce Website Development',
        description:
            'Need a developer to create an e-commerce website for a local clothing store. The website should have product listings, shopping cart, and integration with BaridiMob payment.',
        clientId: 'client-1',
        category: 'Web Development',
        requiredSkills: ['HTML', 'CSS', 'JavaScript', 'PHP'],
        minBudget: 50000,
        maxBudget: 80000,
        deadline: now.add(const Duration(days: 30)),
        status: 'open',
        postedDate: now.subtract(const Duration(days: 5)),
      );

      final job2 = JobModel(
        id: 'job-2',
        title: 'Company Logo Design',
        description:
            'Looking for a creative graphic designer to create a modern logo for our tech startup.',
        clientId: 'client-2',
        category: 'Graphic Design',
        requiredSkills: ['Logo Design', 'Adobe Illustrator', 'Creative Design'],
        minBudget: 15000,
        maxBudget: 25000,
        deadline: now.add(const Duration(days: 15)),
        status: 'open',
        postedDate: now.subtract(const Duration(days: 3)),
      );

      final job3 = JobModel(
        id: 'job-3',
        title: 'Mobile App Development',
        description:
            'Need a Flutter developer to create a mobile app for food delivery service.',
        clientId: 'client-1',
        category: 'Mobile Development',
        requiredSkills: ['Flutter', 'Dart', 'Firebase', 'UI/UX'],
        minBudget: 70000,
        maxBudget: 120000,
        deadline: now.add(const Duration(days: 45)),
        status: 'open',
        postedDate: now.subtract(const Duration(days: 2)),
      );

      // Save demo jobs
      List<String> jobsJson = [];
      jobsJson.add(jsonEncode(job1.toMap()));
      jobsJson.add(jsonEncode(job2.toMap()));
      jobsJson.add(jsonEncode(job3.toMap()));

      await prefs.setStringList(_jobsKey, jobsJson);

      // Create demo bids
      final bid1 = BidModel(
        id: 'bid-1',
        jobId: 'job-1',
        freelancerId: 'freelancer-1',
        amount: 75000,
        deliveryTimeInDays: 25,
        coverLetter:
            'I have extensive experience in e-commerce development and can deliver a high-quality website with all the requested features.',
        status: 'pending',
        submittedDate: now.subtract(const Duration(days: 1)),
      );

      final bid2 = BidModel(
        id: 'bid-2',
        jobId: 'job-2',
        freelancerId: 'freelancer-2',
        amount: 20000,
        deliveryTimeInDays: 7,
        coverLetter:
            'As a branding specialist, I can create a modern logo that perfectly represents your tech startup identity.',
        status: 'pending',
        submittedDate: now.subtract(const Duration(hours: 12)),
      );

      // Save demo bids
      List<String> bidsJson = [];
      bidsJson.add(jsonEncode(bid1.toMap()));
      bidsJson.add(jsonEncode(bid2.toMap()));

      await prefs.setStringList(_bidsKey, bidsJson);

      // Mark demo data as initialized
      await prefs.setBool('has_demo_data', true);
    }
  }
}

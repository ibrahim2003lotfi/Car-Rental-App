import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cars/auth/auth_sevice.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final user = authService.value.currentUser;
    final fullName = user?.displayName ?? '';
    final email = user?.email ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: const Text(
          "Account Info",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(15),
              children: [
                _infoHeader(fullName, email),
                const SizedBox(height: 16),
                _tile(
                  title: "Change Username",
                  onTap: () => _changeUsername(context, currentEmail: email),
                ),
                _tile(
                  title: "Change Email",
                  onTap: () => _changeEmail(context, currentEmail: email),
                ),
                _tile(
                  title: "Change Password",
                  onTap: () => _changePassword(context, currentEmail: email),
                ),
                _tile(
                  title: "Delete Account",
                  destructive: true,
                  onTap: () => _deleteAccount(context, currentEmail: email),
                ),
              ],
            ),
            if (_busy) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _infoHeader(String name, String email) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : "No Name",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required String title,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: destructive ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _changeUsername(
    BuildContext context, {
    required String currentEmail,
  }) async {
    final controller = TextEditingController();
    final newName = await _promptOneField(
      context,
      title: "Change Username",
      label: "New username",
      controller: controller,
      validator: (v) => (v == null || v.trim().length < 2)
          ? "Enter at least 2 characters"
          : null,
    );
    if (newName == null) return;

    final confirmed = await _confirm(
      context,
      "Change Username",
      "Are you sure you want to change your username?",
    );
    if (!confirmed) return;

    await _run(() async {
      await authService.value.updateUserName(username: newName.trim());
      _toast("Username updated");
    });
  }

  Future<void> _changeEmail(
    BuildContext context, {
    required String currentEmail,
  }) async {
    final passCtrl = TextEditingController();
    final emailCtrl = TextEditingController(text: currentEmail);
    final result = await _promptTwoFields(
      context,
      title: "Change Email",
      label1: "Current password",
      controller1: passCtrl,
      obscure1: true,
      label2: "New email",
      controller2: emailCtrl,
      validator2: (v) =>
          (v == null || !v.contains('@')) ? "Enter a valid email" : null,
    );
    if (result == null) return;

    final confirmed = await _confirm(
      context,
      "Change Email",
      "We’ll send a verification link to the new email. Continue?",
    );
    if (!confirmed) return;

    await _run(() async {
      await authService.value.updateEmailFromCurrentPassword(
        email: currentEmail,
        currentPassword: passCtrl.text.trim(),
        newEmail: emailCtrl.text.trim(),
      );
      _toast("Check your new email to verify the change");
    });
  }

  Future<void> _changePassword(
    BuildContext context, {
    required String currentEmail,
  }) async {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final result = await _promptTwoFields(
      context,
      title: "Change Password",
      label1: "Current password",
      controller1: currentCtrl,
      obscure1: true,
      label2: "New password",
      controller2: newCtrl,
      obscure2: true,
      validator2: (v) =>
          (v == null || v.length < 6) ? "At least 6 characters" : null,
    );
    if (result == null) return;

    final confirmed = await _confirm(
      context,
      "Change Password",
      "Are you sure you want to change your password?",
    );
    if (!confirmed) return;

    await _run(() async {
      await authService.value.resetPasswordFromCurrentPassword(
        email: currentEmail,
        currentPassword: currentCtrl.text.trim(),
        newPassword: newCtrl.text.trim(),
      );
      _toast("Password updated");
    });
  }

  Future<void> _deleteAccount(
    BuildContext context, {
    required String currentEmail,
  }) async {
    final passCtrl = TextEditingController();
    final password = await _promptOneField(
      context,
      title: "Delete Account",
      label: "Enter password to confirm",
      controller: passCtrl,
      obscure: true,
      validator: (v) =>
          (v == null || v.isEmpty) ? "Password is required" : null,
      primaryActionText: "Continue",
    );
    if (password == null) return;

    final confirmed = await _confirm(
      context,
      "Delete Account",
      "This action cannot be undone. Are you sure?",
      destructive: true,
    );
    if (!confirmed) return;

    await _run(() async {
      await authService.value.deleteAccount(
        email: currentEmail,
        password: passCtrl.text.trim(),
      );
      _toast("Account deleted");
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      }
    });
  }

  Future<String?> _promptOneField(
    BuildContext context, {
    required String title,
    required String label,
    required TextEditingController controller,
    String primaryActionText = "Save",
    bool obscure = false,
    String? Function(String?)? validator,
  }) async {
    final formKey = GlobalKey<FormState>();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(labelText: label),
            validator: validator,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? true) {
                Navigator.pop(ctx, controller.text);
              }
            },
            child: Text(primaryActionText),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _promptTwoFields(
    BuildContext context, {
    required String title,
    required String label1,
    required TextEditingController controller1,
    bool obscure1 = false,
    required String label2,
    required TextEditingController controller2,
    bool obscure2 = false,
    String? Function(String?)? validator2,
  }) async {
    final formKey = GlobalKey<FormState>();
    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller1,
                obscureText: obscure1,
                decoration: InputDecoration(labelText: label1),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "This field is required" : null,
              ),
              TextFormField(
                controller: controller2,
                obscureText: obscure2,
                decoration: InputDecoration(labelText: label2),
                validator: validator2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? true) {
                Navigator.pop(ctx, {
                  'first': controller1.text,
                  'second': controller2.text,
                });
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String message, {
    bool destructive = false,
  }) async {
    return (await showDialog<bool>(
          context: context,
          builder: (ctx) => SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: destructive ? Colors.red : Colors.black,
                ),
              ),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: destructive ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      setState(() => _busy = true);
      await action();
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? e.code);
    } catch (e) {
      _toast(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// lib/pages/change_password_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChangePasswordProvider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordProvider =
    Provider.of<ChangePasswordProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFF062029),
      appBar: AppBar(
        backgroundColor: const Color(0xFF062029),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 24.0,
            letterSpacing: 0.0,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: passwordProvider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // Instruction Text
              Text(
                'Your password must meet the following requirements:',
                style: TextStyle(color: Colors.white70, fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              // Password Requirements
              _buildPasswordRequirements(passwordProvider),
              SizedBox(height: 24.0),
              // New Password Field
              _buildPasswordField(
                controller: passwordProvider.newPasswordController,
                obscureText: passwordProvider.isNewPasswordObscured,
                labelText: 'New Password',
                onChanged: passwordProvider.updatePasswordValidity,
                onToggleVisibility: passwordProvider.setIsNewPasswordObscured,
                validator: passwordProvider.handleNewPassword,
              ),
              SizedBox(height: 16.0),
              // Confirm New Password Field
              _buildPasswordField(
                controller: passwordProvider.confirmPasswordController,
                obscureText: passwordProvider.isConfirmPasswordObscured,
                labelText: 'Confirm Password',
                onToggleVisibility:
                passwordProvider.setIsConfirmPasswordObscured,
                validator: passwordProvider.handleConfirmPassword,
              ),
              SizedBox(height: 32.0),
              // Change Password Button
              _buildActionButton(
                context: context,
                text: 'Change Password',
                onPressed: () =>
                    passwordProvider.handleChangePassword(context),
                backgroundColor: const Color(0xFFDF8B47),
                textColor: Colors.white,
              ),
              SizedBox(height: 16.0),
              // Cancel Button
              _buildActionButton(
                context: context,
                text: 'Cancel',
                onPressed: () => passwordProvider.handleCancel(context),
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                borderColor: Colors.white,
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for password requirements
  Widget _buildPasswordRequirements(ChangePasswordProvider passwordProvider) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          _buildRequirementRow(
            'At least 8 characters',
            passwordProvider.isLengthValid,
          ),
          _buildRequirementRow(
            'Contains uppercase letters',
            passwordProvider.hasUppercase,
          ),
          _buildRequirementRow(
            'Contains lowercase letters',
            passwordProvider.hasLowercase,
          ),
          _buildRequirementRow(
            'Includes numbers',
            passwordProvider.hasDigit,
          ),
          _buildRequirementRow(
            'Has special characters (@, #, %, &, etc.)',
            passwordProvider.hasSpecialChar,
          ),
        ],
      ),
    );
  }

  // Widget for each requirement row
  Widget _buildRequirementRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white70, fontSize: 14.0),
          ),
        ),
      ],
    );
  }

  // Widget for password fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String labelText,
    required VoidCallback onToggleVisibility,
    required FormFieldValidator<String> validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  // Widget for action buttons
  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 2.0)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
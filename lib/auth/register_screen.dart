import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/theme_provider.dart';

enum PlanType { free, silver, gold, platinum }
enum RegisterStep { details, otp, plan }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _otpController = TextEditingController();
  final _imagePicker = ImagePicker();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  PlanType _selectedPlan = PlanType.free;
  String _generatedReferralCode = '';
  File? _profileImage;
  RegisterStep _currentStep = RegisterStep.details;
  String _otp = '123456';
  int _otpAttempts = 0;
  bool _canResendOtp = false;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _generateReferralCode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _generateReferralCode() {
    final uuid = const Uuid();
    _generatedReferralCode = uuid.v4().substring(0, 5).toUpperCase();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _otpAttempts = 0;
      _canResendOtp = false;
      _resendCountdown = 30;
    });

    try {
      // TODO: Implement OTP sending logic
      await Future.delayed(const Duration(seconds: 2)); // Simulated API call
      
      // Use static OTP for demo
      _otp = '123456';
      
      if (!mounted) return;
      setState(() {
        _currentStep = RegisterStep.otp;
        _isLoading = false;
      });
      
      // Start countdown for resend
      _startResendCountdown();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully! Use 123456 for testing'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
          _startResendCountdown();
        } else {
          _canResendOtp = true;
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement OTP verification logic
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      
      if (_otpController.text == '123456') {
        if (!mounted) return;
        setState(() {
          _currentStep = RegisterStep.plan;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _otpAttempts++;
        if (_otpAttempts >= 3) {
          throw Exception('Too many invalid attempts. Please request a new OTP.');
        }
        throw Exception('Invalid OTP. ${3 - _otpAttempts} attempts remaining.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
        if (_otpAttempts >= 3) {
          _canResendOtp = true;
        }
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement registration API call with profile image
      await Future.delayed(const Duration(seconds: 2)); // Simulated API call
      
      if (!mounted) return;

      if (_selectedPlan == PlanType.free) {
        // Navigate to homepage for free plan
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Convert PlanType to String for payment screen
        final planString = _selectedPlan.toString().split('.').last;
        
        // Navigate to payment screen for paid plans
        Navigator.pushNamed(
          context,
          '/payment',
          arguments: {
            'plan': planString,
            'amount': _getPlanAmount(_selectedPlan),
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _getPlanAmount(PlanType plan) {
    switch (plan) {
      case PlanType.silver:
        return 10.0;
      case PlanType.gold:
        return 20.0;
      case PlanType.platinum:
        return 30.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(1, 'Details', _currentStep == RegisterStep.details),
                    Container(
                      width: 50,
                      height: 2,
                      color: _currentStep.index >= 1 ? theme.primaryColor : Colors.grey,
                    ),
                    _buildStepIndicator(2, 'OTP', _currentStep == RegisterStep.otp),
                    Container(
                      width: 50,
                      height: 2,
                      color: _currentStep.index >= 2 ? theme.primaryColor : Colors.grey,
                    ),
                    _buildStepIndicator(3, 'Plan', _currentStep == RegisterStep.plan),
                  ],
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 32),

                // Registration Details Step
                if (_currentStep == RegisterStep.details) ...[
                  // Profile Picture
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _showImagePickerModal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),

                  const SizedBox(height: 24),

                  // Form Fields
                  _buildFormFields(theme),

                  const SizedBox(height: 24),

                  // Next Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 2000))
                  .slideY(begin: 0.3, end: 0),
                ],

                // OTP Verification Step
                if (_currentStep == RegisterStep.otp) ...[
                  Icon(
                    Icons.verified_user,
                    size: 80,
                    color: theme.primaryColor,
                  )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 600))
                  .scale(delay: const Duration(milliseconds: 200)),

                  const SizedBox(height: 24),

                  Text(
                    'Verify Your Phone',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.3, end: 0),

                  Text(
                    'Enter the 6-digit code sent to your phone\nUse 123456 for testing',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 600))
                  .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorMaxLines: 2,
                      helperText: 'Use 123456 for testing',
                      helperStyle: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 800))
                  .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 16),

                  // Resend OTP Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (_canResendOtp)
                        TextButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Text(
                          'Resend in $_resendCountdown s',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 900)),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 1000))
                  .slideY(begin: 0.3, end: 0),

                  // Back Button
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _currentStep = RegisterStep.details;
                              _otpController.clear();
                              _otpAttempts = 0;
                            });
                          },
                    child: Text(
                      'Back to Details',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 1100)),
                ],

                // Plan Selection Step
                if (_currentStep == RegisterStep.plan) ...[
                  Text(
                    'Select Your Plan',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 32),

                  // Plan Cards
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPlanCard(
                        PlanType.free,
                        'Free',
                        '₹0',
                        'Basic features',
                        theme,
                      ),
                      _buildPlanCard(
                        PlanType.silver,
                        'Silver',
                        '₹10',
                        'Premium features',
                        theme,
                      ),
                      _buildPlanCard(
                        PlanType.gold,
                        'Gold',
                        '₹20',
                        'Advanced features',
                        theme,
                      ),
                      _buildPlanCard(
                        PlanType.platinum,
                        'Platinum',
                        '₹30',
                        'All features',
                        theme,
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 600))
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Complete Registration',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 800))
                  .slideY(begin: 0.3, end: 0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? theme.primaryColor : Colors.grey,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? theme.primaryColor : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      children: [
        // Name Field
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600))
        .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        // Email Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 800))
        .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        // Phone Field
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1000))
        .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1200))
        .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1400))
        .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        // Referral Code Field
        TextFormField(
          controller: _referralCodeController,
          decoration: InputDecoration(
            labelText: 'Referral Code (Optional)',
            prefixIcon: const Icon(Icons.card_giftcard),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1600))
        .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildPlanCard(
    PlanType plan,
    String title,
    String price,
    String description,
    ThemeData theme,
  ) {
    final isSelected = _selectedPlan == plan;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlan = plan;
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? theme.primaryColor : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isSelected ? theme.primaryColor : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? theme.primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
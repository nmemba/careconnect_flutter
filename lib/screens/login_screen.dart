import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passcodeController = TextEditingController();
  bool _showPassword = false;
  bool _showPasscode = false;
  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  Future<void> _handleBiometric(AppProvider appProvider) async {
    // Simulate biometric authentication
    await Future.delayed(const Duration(milliseconds: 500));
    await appProvider.login();
    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _handlePasscodeLogin(AppProvider appProvider) async {
    if (_passcodeController.text.length >= 4) {
      await appProvider.login();
      if (mounted) {
        context.go('/');
      }
    }
  }

  Future<void> _handleUsernamePasswordLogin(AppProvider appProvider) async {
    setState(() => _loginError = null);

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _loginError = 'Please enter both username and password');
      return;
    }

    // Demo credentials
    if (_usernameController.text == 'demo' && _passwordController.text == 'demo123') {
      await appProvider.login();
      if (mounted) {
        context.go('/');
      }
    } else {
      setState(() => _loginError = 'Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 32 : 24,
            vertical: isLandscape ? 16 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLandscape ? 500 : 400,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: isLandscape ? 64 : 80,
                    height: isLandscape ? 64 : 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(isLandscape ? 16 : 24),
                    ),
                    child: Center(
                      child: Text(
                        'CC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isLandscape ? 24 : 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isLandscape ? 12 : 24),
                  
                  // Title
                  Text(
                    'CareConnect',
                    style: TextStyle(
                      fontSize: isLandscape ? 24 : 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.grayDark,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 4 : 8),
                  
                  Text(
                    'Your health, simplified',
                    style: TextStyle(
                      fontSize: isLandscape ? 14 : 16,
                      color: AppTheme.grayMedium,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 24 : 32),
                  
                  if (!_showPasscode) ...[
                    // Username & Password Form
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: isLandscape ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.grayDark,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 12 : 16),
                            
                            if (_loginError != null)
                              Container(
                                margin: EdgeInsets.only(bottom: isLandscape ? 12 : 16),
                                padding: EdgeInsets.all(isLandscape ? 12 : 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorBg,
                                  border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                ),
                                child: Text(
                                  _loginError!,
                                  style: const TextStyle(
                                    color: AppTheme.errorColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            
                            // Username
                            Text(
                              'Username',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.grayDark,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 4 : 8),
                            
                            TextField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  size: isLandscape ? 20 : 24,
                                ),
                                constraints: BoxConstraints(
                                  minHeight: isLandscape 
                                      ? AppTheme.minTouchTargetLandscape 
                                      : AppTheme.minTouchTarget,
                                ),
                              ),
                            ),
                            SizedBox(height: isLandscape ? 12 : 16),
                            
                            // Password
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.grayDark,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 4 : 8),
                            
                            TextField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  size: isLandscape ? 20 : 24,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword 
                                        ? Icons.visibility_off 
                                        : Icons.visibility,
                                    size: isLandscape ? 20 : 24,
                                  ),
                                  onPressed: () {
                                    setState(() => _showPassword = !_showPassword);
                                  },
                                ),
                                constraints: BoxConstraints(
                                  minHeight: isLandscape 
                                      ? AppTheme.minTouchTargetLandscape 
                                      : AppTheme.minTouchTarget,
                                ),
                              ),
                            ),
                            SizedBox(height: isLandscape ? 12 : 16),
                            
                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _handleUsernamePasswordLogin(appProvider),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    double.infinity,
                                    isLandscape 
                                        ? AppTheme.minTouchTargetLandscape 
                                        : AppTheme.minTouchTarget,
                                  ),
                                ),
                                child: const Text('Sign In'),
                              ),
                            ),
                            SizedBox(height: isLandscape ? 8 : 12),
                            
                            // Demo credentials hint
                            Text(
                              'Demo credentials: username: demo, password: demo123',
                              style: TextStyle(
                                fontSize: isLandscape ? 10 : 12,
                                color: AppTheme.grayMedium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isLandscape ? 12 : 16),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(color: AppTheme.grayBorder)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or sign in with',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                                color: AppTheme.grayMedium,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppTheme.grayBorder)),
                        ],
                      ),
                    ),
                    
                    // Alternative Login Methods
                    if (appProvider.biometricEnabled)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _handleBiometric(appProvider),
                          icon: Icon(
                            Icons.fingerprint,
                            size: isLandscape ? 20 : 24,
                          ),
                          label: Text(
                            'Sign in with Biometrics',
                            style: TextStyle(fontSize: isLandscape ? 14 : 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                              double.infinity,
                              isLandscape 
                                  ? AppTheme.minTouchTargetLandscape 
                                  : AppTheme.minTouchTarget,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: isLandscape ? 8 : 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _showPasscode = true),
                        icon: Icon(
                          Icons.lock_outline,
                          size: isLandscape ? 20 : 24,
                        ),
                        label: Text(
                          'Use Passcode',
                          style: TextStyle(fontSize: isLandscape ? 14 : 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(
                            double.infinity,
                            isLandscape 
                                ? AppTheme.minTouchTargetLandscape 
                                : AppTheme.minTouchTarget,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Passcode Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Passcode',
                          style: TextStyle(
                            fontSize: isLandscape ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.grayDark,
                          ),
                        ),
                        SizedBox(height: isLandscape ? 4 : 8),
                        
                        TextField(
                          controller: _passcodeController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 8,
                          ),
                          decoration: InputDecoration(
                            hintText: '••••',
                            counterText: '',
                            constraints: BoxConstraints(
                              minHeight: isLandscape 
                                  ? AppTheme.minTouchTargetLandscape 
                                  : AppTheme.minTouchTarget,
                            ),
                          ),
                          autofocus: true,
                        ),
                        SizedBox(height: isLandscape ? 12 : 16),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _passcodeController.text.length >= 4
                                ? () => _handlePasscodeLogin(appProvider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                isLandscape 
                                    ? AppTheme.minTouchTargetLandscape 
                                    : AppTheme.minTouchTarget,
                              ),
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),
                        SizedBox(height: isLandscape ? 8 : 12),
                        
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _showPasscode = false;
                                _passcodeController.clear();
                              });
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                isLandscape 
                                    ? AppTheme.minTouchTargetLandscape 
                                    : AppTheme.minTouchTarget,
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

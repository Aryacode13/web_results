import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'race_results_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  State<TermsConditionsPage> createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  String selectedMenuItem = 'T&C';
  bool isMobileMenuOpen = false;

  final List<String> menuItems = [
    'Home',
    'Race Results',
    'Pricing',
    'Features',
    'Contact',
    'FAQ',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Blue Header (responsive)
          Container(
            height: isMobile ? 70 : 80,
            decoration: const BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 20,
              ),
              child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
            ),
          ),
          
          // Terms & Conditions Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content with padding
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 16 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: isMobile ? 6 : 8),
                        Text(
                          'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 30),
                        
                        // Section 1
                        _buildSection(
                          '1. Acceptance of Terms',
                          'By accessing and using the Running Dashboard application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                          context,
                        ),
                        
                        // Section 2
                        _buildSection(
                          '2. Use License',
                          'Permission is granted to temporarily download one copy of the Running Dashboard application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to reverse engineer any software contained in the application\n• Remove any copyright or other proprietary notations from the materials',
                          context,
                        ),
                        
                        // Section 3
                        _buildSection(
                          '3. Disclaimer',
                          'The materials within the Running Dashboard application are provided on an "as is" basis. Running Dashboard makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
                          context,
                        ),
                        
                        // Section 4
                        _buildSection(
                          '4. Limitations',
                          'In no event shall Running Dashboard or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on the Running Dashboard application, even if Running Dashboard or an authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.',
                          context,
                        ),
                        
                        // Section 5
                        _buildSection(
                          '5. Privacy Policy',
                          'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our service. By using our service, you agree to the collection and use of information in accordance with this policy.',
                          context,
                        ),
                        
                        // Section 6
                        _buildSection(
                          '6. User Accounts',
                          'When you create an account with us, you must provide information that is accurate, complete, and current at all times. You are responsible for safeguarding the password and for all activities that occur under your account.',
                          context,
                        ),
                        
                        // Section 7
                        _buildSection(
                          '7. Prohibited Uses',
                          'You may not use our service:\n\n• For any unlawful purpose or to solicit others to perform unlawful acts\n• To violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances\n• To infringe upon or violate our intellectual property rights or the intellectual property rights of others\n• To harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate\n• To submit false or misleading information',
                          context,
                        ),
                        
                        // Section 8
                        _buildSection(
                          '8. Termination',
                          'We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.',
                          context,
                        ),
                        
                        // Section 9
                        _buildSection(
                          '9. Changes to Terms',
                          'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect.',
                          context,
                        ),
                        
                        // Section 10
                        _buildSection(
                          '10. Contact Information',
                          'If you have any questions about these Terms & Conditions, please contact us at:\n\nEmail: support@runningdashboard.com\nPhone: +1 (555) 123-4567\nAddress: 123 Running Street, Fitness City, FC 12345',
                          context,
                        ),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  
                  // Footer - Full width outside padding
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 16 : 20,
                      horizontal: isMobile ? 16 : 20,
                    ),
                    child: isMobile ? _buildMobileFooter(context) : _buildDesktopFooter(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 20 : 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 10),
          Text(
            content,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Navigation Links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMobileFooterLink(context, 'Home'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Race Results'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Pricing'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Features'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'T&C'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Contact'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'FAQ'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // WhatsApp Link
          GestureDetector(
            onTap: _openWhatsApp,
            child: Text(
              'Request Quote (via WhatsApp)',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Email Address
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: Colors.grey[700],
                size: 16,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  'runmlgrun@gmail.com',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      children: [
        // Left: Navigation links
        Row(
          children: [
            _buildFooterLink(context, 'Home'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Race Results'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Pricing'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Features'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'T&C'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Contact'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'FAQ'),
          ],
        ),
        
        const Spacer(),
        
        // Center: WhatsApp Link
        GestureDetector(
          onTap: _openWhatsApp,
          child: Text(
            'Request Quote (via WhatsApp)',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        
        const Spacer(),
        
        // Right: Email Address
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.email,
              color: Colors.grey[700],
              size: 16,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening email...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'runmlgrun@gmail.com',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'Home') {
          Navigator.pop(context); // Go back to dashboard
    } else if (text == 'Race Results') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      );
    } else if (text == 'Pricing') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      );
    } else if (text == 'Features') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      );
    } else if (text == 'Contact') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    } else if (text == 'FAQ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (text == 'T&C') {
          // Already on T&C page
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$text page coming soon!'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: text == 'T&C' ? Colors.blue : Colors.grey[700],
          fontSize: 14,
          fontWeight: text == 'T&C' ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooterSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMobileFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'T&C') {
          // Already on T&C page
          return;
        }
        // Navigate back to dashboard for other links
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to: $text'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: text == 'T&C' ? Colors.blue : Colors.grey[700],
          fontSize: 14,
          fontWeight: text == 'T&C' ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMobileFooterSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Row(
      children: [
        // Logo
        Container(
          height: 150, // Sama untuk mobile dan desktop
          width: 150,  // Sama untuk mobile dan desktop
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lariterus_logo-removebg-preview.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 80, // Sama untuk mobile dan desktop
                  ),
                );
              },
            ),
          ),
        ),
        
        const Spacer(),
        
        // Hamburger Menu
        GestureDetector(
          onTap: () {
            setState(() {
              isMobileMenuOpen = !isMobileMenuOpen;
            });
            _showMobileMenu();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      children: [
        // Logo
        Container(
          height: 150, // Sama untuk mobile dan desktop
          width: 150,  // Sama untuk mobile dan desktop
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lariterus_logo-removebg-preview.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 80, // Sama untuk mobile dan desktop
                  ),
                );
              },
            ),
          ),
        ),
        
        const Spacer(),
        
        // Navigation Menu
        Row(
          children: menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 30),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMenuItem = item;
                  });
                  _handleNavigation(item);
                },
                child: Text(
                  item,
                  style: TextStyle(
                    color: selectedMenuItem == item 
                        ? Colors.white 
                        : Colors.white70,
                    fontSize: 16,
                    fontWeight: selectedMenuItem == item 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    decoration: selectedMenuItem == item 
                        ? TextDecoration.underline 
                        : null,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(width: 20),
        
        // Search Icon
        GestureDetector(
          onTap: () {
            // Navigate to search page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Menu title
              const Text(
                'Navigation Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              
              // Menu items
              ...menuItems.map((item) {
                return ListTile(
                  leading: Icon(
                    _getMenuIcon(item),
                    color: selectedMenuItem == item ? Colors.blue : Colors.grey[600],
                  ),
                  title: Text(
                    item,
                    style: TextStyle(
                      color: selectedMenuItem == item ? Colors.blue : Colors.grey[800],
                      fontWeight: selectedMenuItem == item ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedMenuItem = item;
                      isMobileMenuOpen = false;
                    });
                    Navigator.pop(context);
                    _handleNavigation(item);
                  },
                );
              }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(String item) {
    if (item == 'Home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (item == 'Race Results') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      );
    } else if (item == 'Pricing') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      );
    } else if (item == 'Features') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      );
    } else if (item == 'Contact') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    } else if (item == 'FAQ') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (item == 'T&C') {
      // Already on T&C page
    } else if (item == 'Search') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item page coming soon!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _openWhatsApp() async {
    const whatsappUrl = 'https://api.whatsapp.com/send/?phone=6285708700863&text=Halo%2C%0A%0ASaya+tertarik+untuk+mengetahui+lebih+lanjut+tentang+solusi+pencatatan+waktu+balap+berbasis+RFID+yang+Anda+tawarkan.+Bisakah+Anda+memberikan+informasi+lebih+lanjut+mengenai+layanan+dan+paket+harga+yang+tersedia%3F&type=phone_number&app_absent=0';
    
    try {
      final Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka WhatsApp'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat membuka WhatsApp'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  IconData _getMenuIcon(String item) {
    switch (item) {
      case 'Home':
        return Icons.home;
      case 'Race Results':
        return Icons.emoji_events;
      case 'Pricing':
        return Icons.attach_money;
      case 'Features':
        return Icons.star;
      case 'Contact':
        return Icons.contact_mail;
      case 'FAQ':
        return Icons.help;
      default:
        return Icons.circle;
    }
  }
}

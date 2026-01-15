import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/responsive.dart';

class FundScreen extends StatelessWidget {
  const FundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Fund DUAAB\'89'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              color: const Color(0xFF2f2c6d),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.wp(context, 6),
                vertical: Responsive.hp(context, 3),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: Responsive.wp(context, 15),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  SizedBox(height: Responsive.hp(context, 1.5)),
                  Text(
                    'Support DUAAB\'89',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 26,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Responsive.hp(context, 0.5)),
                  Text(
                    'Your contribution helps sustain our bond',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 13,
                        tablet: 15,
                        desktop: 14,
                      ),
                      color: Colors.white.withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(Responsive.wp(context, 5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Section
                  _buildMessageCard(context),
                  SizedBox(height: Responsive.hp(context, 3)),

                  // Donation Methods
                  Text(
                    'Donate Your Fund Here',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 22,
                        tablet: 26,
                        desktop: 24,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 2)),

                  // bKash Card
                  _buildDonationCard(
                    context,
                    icon: Icons.phone_android,
                    title: 'bKash',
                    details: '+880 1317-644888',
                    color: Colors.pink.shade600,
                  ),
                  SizedBox(height: Responsive.hp(context, 2)),

                  // Bank Card
                  _buildBankCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.amber.shade700,
            size: Responsive.wp(context, 8),
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'DUAAB\'89 is not just an association - it is a shared memory, a lifelong bond, and a collective responsibility we carry with pride. Over the years, our unity and goodwill have allowed us to stand beside one another in moments of joy, challenge, and growth.',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 15,
              ),
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'To continue our ongoing activities, strengthen member support, and plan meaningful initiatives for the future, we are initiating a fund collection for DUAAB\'89. Your contribution, big or small, will directly support our programs and help sustain the spirit of togetherness that defines our batch.',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 15,
              ),
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'This is a humble call to participate in building something enduring - an organization that reflects our values, our friendships, and our commitment to one another.',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 15,
              ),
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'We sincerely appreciate your generosity, trust, and continued involvement. Together, we move forward - stronger and united.',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 15,
              ),
              height: 1.6,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String details,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.wp(context, 3)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Responsive.wp(context, 2)),
            ),
            child: Icon(
              icon,
              color: color,
              size: Responsive.wp(context, 8),
            ),
          ),
          SizedBox(width: Responsive.wp(context, 4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 17,
                    ),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: Responsive.hp(context, 0.5)),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 19,
                    ),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: color),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: details));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied: $details'),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard(BuildContext context) {
    const bankColor = Color(0xFF1565C0);

    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        border: Border.all(color: bankColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.wp(context, 3)),
                decoration: BoxDecoration(
                  color: bankColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(Responsive.wp(context, 2)),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: bankColor,
                  size: Responsive.wp(context, 8),
                ),
              ),
              SizedBox(width: Responsive.wp(context, 4)),
              Text(
                'City Bank PLC',
                style: TextStyle(
                  fontSize: Responsive.valueWhen(
                    context,
                    mobile: 18,
                    tablet: 20,
                    desktop: 19,
                  ),
                  fontWeight: FontWeight.bold,
                  color: bankColor,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          _buildBankDetail(
              context, 'Account Name', 'DUAAB\'89 Account', bankColor),
          SizedBox(height: Responsive.hp(context, 1.5)),
          _buildBankDetail(
              context, 'Account Number', '1222789867001', bankColor),
          SizedBox(height: Responsive.hp(context, 1.5)),
          _buildBankDetail(
              context, 'Branch', 'Gulshan Avenue Branch', bankColor),
        ],
      ),
    );
  }

  Widget _buildBankDetail(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.wp(context, 3),
        vertical: Responsive.hp(context, 1.5),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.wp(context, 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.valueWhen(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 13,
                  ),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Responsive.hp(context, 0.5)),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.valueWhen(
                    context,
                    mobile: 15,
                    tablet: 17,
                    desktop: 16,
                  ),
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.copy, color: color, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied: $value'),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

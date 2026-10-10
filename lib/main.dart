import 'package:flutter/material.dart';

import 'mortgage.dart';

void main() {
  runApp(const MortgageCalculatorApp());
}

class MortgageCalculatorApp extends StatelessWidget {
  const MortgageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF3157C8);
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FC),
          foregroundColor: Color(0xFF17233C),
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seed, width: 1.5),
          ),
        ),
      ),
      home: const SummaryScreen(),
    );
  }
}

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Mortgage _mortgage = Mortgage();
  bool _acceptedTerms = false;

  Future<void> _modifyMortgage() async {
    final updatedMortgage = await Navigator.of(context).push<Mortgage>(
      MaterialPageRoute(
        builder: (_) => EditMortgageScreen(mortgage: _mortgage),
      ),
    );
    if (updatedMortgage != null && mounted) {
      setState(() {
        _mortgage = updatedMortgage;
        _acceptedTerms = false;
      });
    }
  }

  Future<void> _onTermsChanged(bool? checked) async {
    if (checked != true) {
      setState(() => _acceptedTerms = false);
      return;
    }

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const Text(
          'This calculator provides an estimate for learning purposes. '
          'Your lender may use different rates, fees, and payment schedules.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Decline'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('I Agree'),
          ),
        ],
      ),
    );
    if (mounted) setState(() => _acceptedTerms = accepted == true);
  }

  @override
  Widget build(BuildContext context) {
    final mortgage = _mortgage;
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage Calculator')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Your monthly estimate',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF17233C),
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Review your loan details and estimated payments.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF65718A),
                  ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE5EAF2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryRow(
                      label: 'Loan amount',
                      value: mortgage.formattedAmount,
                    ),
                    const SizedBox(height: 18),
                    _SummaryRow(label: 'Loan term', value: '${mortgage.years} years'),
                    const SizedBox(height: 18),
                    _SummaryRow(
                      label: 'Interest rate',
                      value: mortgage.formattedRate,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(height: 1),
                    ),
                    _SummaryRow(
                      label: 'Monthly payment',
                      value: mortgage.formattedMonthlyPayment,
                      emphasize: true,
                    ),
                    const SizedBox(height: 18),
                    _SummaryRow(
                      label: 'Total payment',
                      value: mortgage.formattedTotalPayment,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Terms and Conditions'),
                      value: _acceptedTerms,
                      onChanged: _onTermsChanged,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _modifyMortgage,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Modify data'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Estimate excludes taxes, insurance, and lender fees.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF78839A),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: emphasize ? const Color(0xFF3157C8) : const Color(0xFF29354D),
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          fontSize: emphasize ? 18 : null,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF68748B),
                ),
          ),
        ),
        const SizedBox(width: 12),
        Text(value, style: style, textAlign: TextAlign.end),
      ],
    );
  }
}

class EditMortgageScreen extends StatefulWidget {
  const EditMortgageScreen({super.key, required this.mortgage});

  final Mortgage mortgage;

  @override
  State<EditMortgageScreen> createState() => _EditMortgageScreenState();
}

class _EditMortgageScreenState extends State<EditMortgageScreen> {
  late final TextEditingController _amountController;
  late int _years;
  late double _rate;
  String? _validationMessage;

  static const List<int> _termOptions = [10, 15, 30];
  static final List<double> _rateOptions = List<double>.generate(
    53,
    (index) => 2 + index * 0.25,
  );

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.mortgage.amount.toStringAsFixed(2),
    );
    _years = widget.mortgage.years;
    _rate = widget.mortgage.rate * 100;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _finishEditing() {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', ''),
    );
    if (amount == null || !amount.isFinite || amount < 0) {
      setState(() => _validationMessage = 'Enter a valid loan amount.');
      return;
    }
    Navigator.of(context).pop(
      Mortgage(amount: amount, years: _years, rate: _rate / 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify loan details'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Adjust your loan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF17233C),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
              child: Text(
                'Choose a term, enter an amount, and select an interest rate.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF65718A),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Loan term',
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
              child: Wrap(
                spacing: 8,
                children: _termOptions.map((years) {
                  return ChoiceChip(
                    label: Text('$years years'),
                    selected: _years == years,
                    onSelected: (_) => setState(() => _years = years),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Loan amount',
                  prefixText: '\$ ',
                  errorText: _validationMessage,
                ),
                onChanged: (_) {
                  if (_validationMessage != null) {
                    setState(() => _validationMessage = null);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Interest rate',
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    '${_rate.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF3157C8),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Scroll to select a rate from 2.00% to 15.00%.',
                style: TextStyle(color: Color(0xFF78839A), fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _rateOptions.length,
                itemBuilder: (context, index) {
                  final rate = _rateOptions[index];
                  return RadioListTile<double>(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text('${rate.toStringAsFixed(2)}%'),
                    value: rate,
                    groupValue: _rate,
                    onChanged: (value) {
                      if (value != null) setState(() => _rate = value);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: _finishEditing,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

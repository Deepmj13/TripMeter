import 'package:flutter_test/flutter_test.dart';
import 'package:tripmeter/core/utils/money.dart';

void main() {
  group('parseMajorToMinor', () {
    test('parses decimal amounts without floating point', () {
      expect(parseMajorToMinor('1250.50', 2), 125050);
      expect(parseMajorToMinor('0.05', 2), 5);
      expect(parseMajorToMinor('1,250.5', 2), 125050);
      expect(parseMajorToMinor('1250', 2), 125000);
      expect(parseMajorToMinor('\u20B912.34', 2), 1234);
      expect(parseMajorToMinor('12', 0), 12);
    });

    test('rejects malformed or over-precise input', () {
      expect(parseMajorToMinor('', 2), isNull);
      expect(parseMajorToMinor('abc', 2), isNull);
      expect(parseMajorToMinor('1.234', 2), isNull);
      expect(parseMajorToMinor('-1.00', 2), isNull);
      expect(parseMajorToMinor('1.2.3', 2), isNull);
    });
  });

  test('minorToMajorInput round-trips', () {
    expect(minorToMajorInput(125050, 2), '1250.50');
    expect(minorToMajorInput(5, 2), '0.05');
    expect(minorToMajorInput(12, 0), '12');
  });

  group('allocateEqualSplit', () {
    test('assigns the remainder deterministically to sorted member IDs', () {
      final allocation = allocateEqualSplit(1000, ['m3', 'm1', 'm2']);
      expect(allocation, {'m1': 334, 'm2': 333, 'm3': 333});
      expect(allocateEqualSplit(1000, ['m1', 'm2', 'm3']), allocation);
    });

    test('handles empty and single-participant splits', () {
      expect(allocateEqualSplit(100, const []), isEmpty);
      expect(allocateEqualSplit(100, ['only']), {'only': 100});
    });

    test('allocations always sum to the input amount', () {
      for (var amount = 0; amount < 100; amount += 1) {
        final allocation = allocateEqualSplit(amount, ['a', 'b', 'c', 'd']);
        expect(
          allocation.values.fold<int>(0, (sum, value) => sum + value),
          amount,
        );
      }
    });
  });
}

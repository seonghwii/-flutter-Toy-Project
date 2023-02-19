import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, code, amount;
  final IconData icon;
  final bool isInverted;
  final _blackColor =
      const Color(0xFF1F2123); // 앞에 _를 붙여줄 경우, private 변수로 작용한다.

  final double cardPosition;

  const CurrencyCard({
    super.key,
    required this.name,
    required this.code,
    required this.amount,
    required this.icon,
    required this.isInverted,
    required this.cardPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0,
        cardPosition,
      ),
      child: Container(
          // 카드 생성
          clipBehavior: Clip.hardEdge, // overflow 부분 설정 장치
          decoration: BoxDecoration(
            color: isInverted ? Colors.white : _blackColor, // 배경색 지정
            borderRadius: BorderRadius.circular(25), // 모서리 둥글게 만들기
          ),
          child: Padding(
            padding: const EdgeInsets.all(30), // padding 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        // 텍스트 꾸미기
                        color: isInverted ? _blackColor : Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      // text 생성
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            // 텍스트 꾸미기
                            color: isInverted ? _blackColor : Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          // 텍스트 사이의 거리 띄우기
                          width: 5,
                        ),
                        Text(
                          code,
                          style: TextStyle(
                            color: isInverted
                                ? _blackColor
                                : Colors.white.withOpacity(0.8),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Transform.scale(
                    // 아이콘 확대 기능
                    scale: 2.2,
                    child: Transform.translate(
                      // 아이콘 위치 조정
                      offset: const Offset(
                        -5,
                        12,
                      ),
                      child: Icon(
                        // 아이콘 생성
                        icon,
                        color: isInverted ? _blackColor : Colors.white,
                        size: 88,
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}

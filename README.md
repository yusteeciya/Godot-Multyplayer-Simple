# Godot-Multyplayer-Simple

Godot Engine 4.7의 내장 고성능 멀티플레이어 API(MultiplayerAPI 및 ENetMultiplayerPeer)를 활용한 간단한 네트워크 멀티플레이어 템플릿입니다. 소규모 네트워크 게임 제작의 기반으로 삼거나 동기화 기초를 학습하기에 적합합니다.

🚀 주요 기능

• 빠른 시작: 서버 생성 및 클라이언트 접속을 위한 준비된 아키텍처 제공.
• 네트워크 매니저: 접속, 연결 해제 및 네트워크 엔티티 생성을 관리하는 network_manager.gd 스크립트 포함.
• 플레이어 동기화: 접속한 각 유저를 위한 플레이어 캐릭터(player.tscn) 자동 스폰 예제.
• 미니멀한 디자인: 복잡한 코드 없이 멀티플레이어의 핵심 기본 기능만 구현.

📁 프로젝트 구조

• network_manager.tscn / network_manager.gd — 네트워크 초기화(호스트/클라이언트) 및 네트워크 이벤트를 처리하는 메인 노드.
• player.tscn / player.gd — 멀티플레이어에 맞게 최적화된 플레이어 캐릭터 씬 및 로직.
• world.tscn — 상호작용이 이루어지는 기본 게임 월드 씬.
• project.godot — Godot 4.7 프로젝트 설정 파일.

⚙️ 설치 및 실행 방법

1. 저장소 클론:bash
git clone https://github.com/yusteeciya/Godot-Multyplayer-Simple
2. 프로젝트 열기: Godot Engine(4.x 버전)에서 해당 프로젝트를 불러옵니다.
3. 멀티플레이어 테스트 (단일 PC 기준):
	• Godot 에디터 상단의 디버그(Debug) -> 여러 인스턴스 실행(Run Multiple Instances) 메뉴로 이동합니다.
	• 실행할 인스턴스 개수를 2개 이상으로 설정합니다.
	• 하나의 인스턴스는 **서버(호스트)**로, 다른 인스턴스는 클라이언트(127.0.0.1로 접속)로 설정하여 테스트합니다.

🛠️ 작동 원리 (요약)

네트워크 매니저는 플레이어의 상태를 추적하기 위해 Godot의 내장 신호(Signal)를 사용합니다:
• peer_connected: 새로운 플레이어가 네트워크에 접속하면 트리거됩니다. 서버는 해당 플레이어를 위해 player.tscn 인스턴스를 자동으로 생성(스폰)합니다.
• peer_disconnected: 플레이어가 게임을 종료하면 해당 플레이어 오브젝트를 자동으로 제거합니다.
실시간 플레이어 위치 및 상태 동기화를 위해 플레이어 씬 내부에 MultiplayerSynchronizer 노드를 활용하는 것을 권장합니다.

📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 LICENSE 파일을 확인하세요.

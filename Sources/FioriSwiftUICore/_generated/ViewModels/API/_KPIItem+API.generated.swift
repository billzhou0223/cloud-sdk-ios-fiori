// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

public struct _KPIItem<Kpi: View, Subtitle: View> {
    @Environment(\.kpiModifier) private var kpiModifier
	@Environment(\.subtitleModifier) private var subtitleModifier

    let _kpi: Kpi
	let _subtitle: Subtitle
	var action: (() -> Void)? = nil
    private var isModelInit: Bool = false
	private var isKpiNil: Bool = false
	private var isSubtitleNil: Bool = false

    public init(
        @ViewBuilder kpi: () -> Kpi,
		@ViewBuilder subtitle: () -> Subtitle
        ) {
            self._kpi = kpi()
			self._subtitle = subtitle()
    }

    @ViewBuilder var kpi: some View {
        if isModelInit {
            _kpi.modifier(kpiModifier.concat(Fiori._KPIItem.kpi).concat(Fiori._KPIItem.kpiCumulative))
        } else {
            _kpi.modifier(kpiModifier.concat(Fiori._KPIItem.kpi))
        }
    }
	@ViewBuilder var subtitle: some View {
        if isModelInit {
            _subtitle.modifier(subtitleModifier.concat(Fiori._KPIItem.subtitle).concat(Fiori._KPIItem.subtitleCumulative))
        } else {
            _subtitle.modifier(subtitleModifier.concat(Fiori._KPIItem.subtitle))
        }
    }
    
	var isKpiEmptyView: Bool {
        ((isModelInit && isKpiNil) || Kpi.self == EmptyView.self) ? true : false
    }

	var isSubtitleEmptyView: Bool {
        ((isModelInit && isSubtitleNil) || Subtitle.self == EmptyView.self) ? true : false
    }
}

extension _KPIItem where Kpi == _ConditionalContent<Text, EmptyView>,
		Subtitle == _ConditionalContent<Text, EmptyView> {

    public init(model: _KPIItemModel) {
        self.init(kpi: model.kpi, subtitle: model.subtitle)
    }

    public init(kpi: String? = nil, subtitle: String? = nil) {
        self._kpi = kpi != nil ? ViewBuilder.buildEither(first: Text(kpi!)) : ViewBuilder.buildEither(second: EmptyView())
		self._subtitle = subtitle != nil ? ViewBuilder.buildEither(first: Text(subtitle!)) : ViewBuilder.buildEither(second: EmptyView())

		isModelInit = true
		isKpiNil = kpi == nil ? true : false
		isSubtitleNil = subtitle == nil ? true : false
    }
}

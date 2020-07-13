<!DOCTYPE html>
<!--
	Tomato GUI
	Copyright (C) 2006-2010 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html lang="en-GB">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<meta name="robots" content="noindex,nofollow">
<title>[<% ident(); %>] Advanced: Wireless</title>
<link rel="stylesheet" type="text/css" href="tomato.css">
<% css(); %>
<script src="tomato.js"></script>
<script src="wireless.jsx?_http_id=<% nv(http_id); %>"></script>
<script>

//	<% nvram("t_model_name,wl_security_mode,wl_afterburner,wl_ap_isolate,wl_auth,wl_bcn,wl_dtim,wl_frag,wl_frameburst,wl_gmode_protection,wl_plcphdr,wl_rate,wl_rateset,wl_rts,wl_wme,wl_wme_no_ack,wl_wme_apsd,wl_txpwr,wl_mrate,t_features,wl_distance,wl_maxassoc,wlx_hpamp,wlx_hperx,wl_reg_mode,wl_country_code,wl_btc_mode,wl_mimo_preamble,wl_obss_coex,wl_mitigation,wl_mitigation_ac,wl_phytype,wl_corerev,wl_igs,wl_wmf_bss_enable,wl_wmf_ucigmp_query,wl_wmf_mdata_sendup,wl_wmf_ucast_upnp,wl_wmf_igmpq_filter,wl_atf,wl_turbo_qam,wl_txbf,wl_txbf_bfr_cap,wl_txbf_bfe_cap,wl_itxbf,wl_txbf_imp"); %>

//	<% wlcountries(); %>

hp = features('hpamp');
nphy = features('11n');

function verifyFields(focused, quiet) {
	for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		if (wl_sunit(uidx) < 0) {
			var u = wl_unit(uidx);

			if (!v_range('_f_wl'+u+'_distance', quiet, 0, 99999)) return 0;
			if (!v_range('_wl'+u+'_maxassoc', quiet, 0, 255)) return 0;
			if (!v_range('_wl'+u+'_bcn', quiet, 1, 65535)) return 0;
			if (!v_range('_wl'+u+'_dtim', quiet, 1, 255)) return 0;
			if (!v_range('_wl'+u+'_frag', quiet, 256, 2346)) return 0;
			if (!v_range('_wl'+u+'_rts', quiet, 0, 2347)) return 0;
			if (!v_range(E('_wl'+u+'_txpwr'), quiet, hp ? 1 : 0, hp ? 251 : 400)) return 0;

			var b = E('_wl'+u+'_wme').value == 'off';
			E('_wl'+u+'_wme_no_ack').disabled = b;
			E('_wl'+u+'_wme_apsd').disabled = b;
		}
	}

	return 1;
}

function save() {
	var fom;
	var n;

	if (!verifyFields(null, false)) return;

	fom = E('t_fom');

	for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		if (wl_sunit(uidx) < 0) {
			var u = wl_unit(uidx);

			n = E('_f_wl'+u+'_distance').value * 1;
			E('_wl'+u+'_distance').value = n ? n : '';

			E('_wl'+u+'_nmode_protection').value = E('_wl'+u+'_gmode_protection').value;

			/* for Explicit TX Beamforming */
			E('_wl'+u+'_txbf_bfr_cap').value = E('_wl'+u+'_txbf').value; /* turn on (1)/off (0) with wl_txbf */
			E('_wl'+u+'_txbf_bfe_cap').value = E('_wl'+u+'_txbf').value;

			/* for Implicit TX Beamforming */
			E('_wl'+u+'_txbf_imp').value = E('_wl'+u+'_itxbf').value; /* turn on (1)/off (0) with wl_itxbf */
/* EMF-BEGIN */
			/* for Wireless IGMP Snooping */
			var wb_enable = E('_wl'+u+'_wmf_bss_enable').value;
			E('_wl'+u+'_igs').value = wb_enable; /* turn on (1)/off (0) with wl_wmf_bss_enable */
			E('_wl'+u+'_wmf_ucigmp_query').value = wb_enable;
			E('_wl'+u+'_wmf_mdata_sendup').value = wb_enable;
			E('_wl'+u+'_wmf_ucast_upnp').value = wb_enable;
			E('_wl'+u+'_wmf_igmpq_filter').value = wb_enable;
/* EMF-END */
		}
	}

	if (hp) {
		if ((E('_wlx_hpamp').value != nvram.wlx_hpamp) || (E('_wlx_hperx').value != nvram.wlx_hperx)) {
			fom._service.disabled = 1;
			fom._reboot.value = 1;
			form.submit(fom, 0);
			return;
		}
	}
	else {
		E('_wlx_hpamp').disabled = 1;
		E('_wlx_hperx').disabled = 1;
	}

	form.submit(fom, 1);
}
</script>
</head>

<body>
<form id="t_fom" method="post" action="tomato.cgi">
<table id="container">
<tr><td colspan="2" id="header">
	<div class="title">FreshTomato</div>
	<div class="version">Version <% version(); %> on <% nv("t_model_name"); %></div>
</td></tr>
<tr id="body"><td id="navi"><script>navi()</script></td>
<td id="content">
<div id="ident"><% ident(); %></div>

<!-- / / / -->

<input type="hidden" name="_nextpage" value="advanced-wireless.asp">
<input type="hidden" name="_nextwait" value="10">
<input type="hidden" name="_service" value="*">
<input type="hidden" name="_reboot" value="0">

<!-- / / / -->

<script>
	for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
		if (wl_sunit(uidx) < 0) {
			var u = wl_unit(uidx);

			W('<input type="hidden" id="_wl'+u+'_distance" name="wl'+u+'_distance">');
			W('<input type="hidden" id="_wl'+u+'_nmode_protection" name="wl'+u+'_nmode_protection">');
			W('<input type="hidden" id="_wl'+u+'_txbf_bfr_cap" name="wl'+u+'_txbf_bfr_cap">');
			W('<input type="hidden" id="_wl'+u+'_txbf_bfe_cap" name="wl'+u+'_txbf_bfe_cap">');
			W('<input type="hidden" id="_wl'+u+'_txbf_imp" name="wl'+u+'_txbf_imp">');
/* EMF-BEGIN */
			W('<input type="hidden" id="_wl'+u+'_igs" name="wl'+u+'_igs">');
			W('<input type="hidden" id="_wl'+u+'_wmf_ucigmp_query" name="wl'+u+'_wmf_ucigmp_query">');
			W('<input type="hidden" id="_wl'+u+'_wmf_mdata_sendup" name="wl'+u+'_wmf_mdata_sendup">');
			W('<input type="hidden" id="_wl'+u+'_wmf_ucast_upnp" name="wl'+u+'_wmf_ucast_upnp">');
			W('<input type="hidden" id="_wl'+u+'_wmf_igmpq_filter" name="wl'+u+'_wmf_igmpq_filter">');
/* EMF-END */

/* / / / */

			W('<div class="section-title">Wireless Settings (' + wl_display_ifname(uidx) + ') <\/div>');
			W('<div class="section">');

			at = ((nvram['wl'+u+'_security_mode'] != "wep") && (nvram['wl'+u+'_security_mode'] != "radius") && (nvram['wl'+u+'_security_mode'] != "disabled"));
			createFieldTable('', [
				{ title: 'Afterburner', name: 'wl'+u+'_afterburner', type: 'select', options: [['auto','Auto'],['on','Enable'],['off','Disable *']],
					value: nvram['wl'+u+'_afterburner'] },
				{ title: 'AP Isolation', name: 'wl'+u+'_ap_isolate', type: 'select', options: [['0','Disable *'],['1','Enable']],
					value: nvram['wl'+u+'_ap_isolate'] },
				{ title: 'Authentication Type', name: 'wl'+u+'_auth', type: 'select',
					options: [['0','Auto *'],['1','Shared Key']], attrib: at ? 'disabled' : '',
					value: at ? 0 : nvram['wl'+u+'_auth'] },
				{ title: 'Basic Rate', name: 'wl'+u+'_rateset', type: 'select', options: [['default','Default *'],['12','1-2 Mbps'],['all','All']],
					value: nvram['wl'+u+'_rateset'] },
				{ title: 'Beacon Interval', name: 'wl'+u+'_bcn', type: 'text', maxlen: 5, size: 7,
					suffix: ' <small>(range: 1 - 65535; default: 100)<\/small>', value: nvram['wl'+u+'_bcn'] },
				{ title: 'CTS Protection Mode', name: 'wl'+u+'_gmode_protection', type: 'select', options: [['off','Disable *'],['auto','Auto']],
					value: nvram['wl'+u+'_gmode_protection'] },
				{ title: 'Regulatory Mode', name: 'wl'+u+'_reg_mode', type: 'select',
					options: [['off', 'Off *'],['d', '802.11d'],['h', '802.11h']],
					value: nvram['wl'+u+'_reg_mode'] },
				{ title: 'Country / Region', name: 'wl'+u+'_country_code', type: 'select',
					options: wl_countries, value: nvram['wl'+u+'_country_code'] },
				{ title: 'Bluetooth Coexistence', name: 'wl'+u+'_btc_mode', type: 'select',
					options: [['0', 'Disable *'],['1', 'Enable'],['2', 'Preemption']],
					value: nvram['wl'+u+'_btc_mode'] },
				{ title: 'Distance / ACK Timing', name: 'f_wl'+u+'_distance', type: 'text', maxlen: 5, size: 7,
					suffix: ' <small>meters<\/small>&nbsp;&nbsp;<small>(range: 0 - 99999; 0 = use default)<\/small>',
						value: (nvram['wl'+u+'_distance'] == '') ? '0' : nvram['wl'+u+'_distance'] },
				{ title: 'DTIM Interval', name: 'wl'+u+'_dtim', type: 'text', maxlen: 3, size: 5,
					suffix: ' <small>(range: 1 - 255; default: 1)<\/small>', value: nvram['wl'+u+'_dtim'] },
				{ title: 'Fragmentation Threshold', name: 'wl'+u+'_frag', type: 'text', maxlen: 4, size: 6,
					suffix: ' <small>(range: 256 - 2346; default: 2346)<\/small>', value: nvram['wl'+u+'_frag'] },
				{ title: 'Frame Burst', name: 'wl'+u+'_frameburst', type: 'select', options: [['off','Disable *'],['on','Enable']],
					value: nvram['wl'+u+'_frameburst'] },
				{ title: 'HP', hidden: !hp || (uidx > 0) },
					{ title: 'Amplifier', indent: 2, name: 'wlx_hpamp' + (uidx > 0 ? uidx + '' : ''), type: 'select', options: [['0','Disable'],['1','Enable *']],
						value: nvram.wlx_hpamp != '0', hidden: !hp || (uidx > 0) },
					{ title: 'Enhanced RX Sensitivity', indent: 2, name: 'wlx_hperx' + (uidx > 0 ? uidx + '' : ''), type: 'select', options: [['0','Disable *'],['1','Enable']],
						value: nvram.wlx_hperx != '0', hidden: !hp || (uidx > 0) },
				{ title: 'Maximum Clients', name: 'wl'+u+'_maxassoc', type: 'text', maxlen: 3, size: 5,
					suffix: ' <small>(range: 1 - 255; default: 128)<\/small>', value: nvram['wl'+u+'_maxassoc'] },
				{ title: 'Multicast Rate', name: 'wl'+u+'_mrate', type: 'select',
					options: [['0','Auto *'],['1000000','1 Mbps'],['2000000','2 Mbps'],['5500000','5.5 Mbps'],['6000000','6 Mbps'],['9000000','9 Mbps'],['11000000','11 Mbps'],['12000000','12 Mbps'],['18000000','18 Mbps'],['24000000','24 Mbps'],['36000000','36 Mbps'],['48000000','48 Mbps'],['54000000','54 Mbps']],
					value: nvram['wl'+u+'_mrate'] },
				{ title: 'Preamble', name: 'wl'+u+'_plcphdr', type: 'select', options: [['long','Long *'],['short','Short']],
					value: nvram['wl'+u+'_plcphdr'] },
				{ title: '802.11n Preamble', name: 'wl'+u+'_mimo_preamble', type: 'select', options: [['auto','Auto'],['mm','Mixed Mode *'],['gf','Green Field'],['gfbcm','GF-BRCM']],
					value: nvram['wl'+u+'_mimo_preamble'], hidden: !nphy },
				{ title: 'Overlapping BSS Coexistence', name: 'wl'+u+'_obss_coex', type: 'select', options: [['0','Off *'],['1','On']],
					value: nvram['wl'+u+'_obss_coex'], hidden: !nphy },
				{ title: 'RTS Threshold', name: 'wl'+u+'_rts', type: 'text', maxlen: 4, size: 6,
					suffix: ' <small>(range: 0 - 2347; default: 2347)<\/small>', value: nvram['wl'+u+'_rts'] },
				{ title: 'Transmit Power', name: 'wl'+u+'_txpwr', type: 'text', maxlen: 3, size: 5,
					suffix: hp ?
						' <small>mW (before amplification)<\/small>&nbsp;&nbsp;<small>(range: 1 - 251; default: 10)<\/small>' :
						' <small>mW<\/small>&nbsp;&nbsp;<small>(range: 0 - 400, override regulatory and other limitations; use 0 for country default)<\/small>',
						value: nvram['wl'+u+'_txpwr'] },
				{ title: 'Transmission Rate', name: 'wl'+u+'_rate', type: 'select',
					options: [['0','Auto *'],['1000000','1 Mbps'],['2000000','2 Mbps'],['5500000','5.5 Mbps'],['6000000','6 Mbps'],['9000000','9 Mbps'],['11000000','11 Mbps'],['12000000','12 Mbps'],['18000000','18 Mbps'],['24000000','24 Mbps'],['36000000','36 Mbps'],['48000000','48 Mbps'],['54000000','54 Mbps']],
					value: nvram['wl'+u+'_rate'] },
				{ title: 'Interference Mitigation', name: 'wl'+u+'_mitigation', type: 'select',
					options: [['0','None *'],['1','Non-WLAN'],['2','WLAN Manual'],['3','WLAN Auto'],['4','WLAN Auto with Noise Reduction']],
					value: nvram['wl'+u+'_mitigation'], hidden: (nvram['wl'+u+'_phytype'] == 'v') },
				{ title: 'AC-PHY Interference Mitigation', name: 'wl'+u+'_mitigation_ac', type: 'select',
					options: [['0','None *'],['1','desense based on glitch count (opt. 1)'],['2','limit pktgain based on hwaci (opt. 2)'],['4','limit pktgain based on w2/nb (opt. 3)'],['3','opt. 1 AND opt. 2'],['5','opt. 1 AND opt. 3'],['6','opt. 2 AND opt. 3'],['7','opt. 1 AND opt. 2 AND opt. 3']],
					value: nvram['wl'+u+'_mitigation_ac'], hidden: (nvram['wl'+u+'_phytype'] != 'v') },
				{ title: 'WMM', name: 'wl'+u+'_wme', type: 'select', options: [['auto','Auto'],['off','Disable'],['on','Enable *']], value: nvram['wl'+u+'_wme'] },
				{ title: 'No ACK', name: 'wl'+u+'_wme_no_ack', indent: 2, type: 'select', options: [['off','Disable *'],['on','Enable']],
					value: nvram['wl'+u+'_wme_no_ack'] },
				{ title: 'APSD Mode', name: 'wl'+u+'_wme_apsd', indent: 2, type: 'select', options: [['off','Disable'],['on','Enable *']],
					value: nvram['wl'+u+'_wme_apsd'] },
				{ title: 'Wireless Multicast Forwarding', name: 'wl'+u+'_wmf_bss_enable', type: 'select', options: [['0','Disable *'],['1','Enable']],
					value: nvram['wl'+u+'_wmf_bss_enable'] },
				{ title: 'Turbo QAM (Requires Wireless Network Mode set to Auto)', name: 'wl'+u+'_turbo_qam', type: 'select', options: [['0','Disable'],['1','Enable *']],
					value: nvram['wl'+u+'_turbo_qam'], hidden: (nvram['wl'+u+'_phytype'] != 'v') },
				{ title: 'Explicit beamforming', name: 'wl'+u+'_txbf', type: 'select', options: [['0','Disable'],['1','Enable *']],
					value: nvram['wl'+u+'_txbf'], hidden: (nvram['wl'+u+'_corerev'] < 40) },
				{ title: 'Universal/Implicit beamforming', name: 'wl'+u+'_itxbf', type: 'select', options: [['0','Disable'],['1','Enable *']],
					value: nvram['wl'+u+'_itxbf'], hidden: (nvram['wl'+u+'_corerev'] < 40) },
				{ title: 'Air Time Fairness', name: 'wl'+u+'_atf', type: 'select', options: [['0','Disable *'],['1','Enable']],
					value: nvram['wl'+u+'_atf'] }
			]);
			W('<\/div>');
		}
	}
</script>

<!-- / / / -->

<div class="section"><small>The default settings are indicated with an asterisk <b style="font-size: 1.5em">*</b> symbol.</small></div>

<!-- / / / -->

<div id="footer">
	<span id="footer-msg"></span>
	<input type="button" value="Save" id="save-button" onclick="save()">
	<input type="button" value="Cancel" id="cancel-button" onclick="reloadPage();">
</div>

</td></tr>
</table>
</form>
<script>verifyFields(null, true);</script>
</body>
</html>

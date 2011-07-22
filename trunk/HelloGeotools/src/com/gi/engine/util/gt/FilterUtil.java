package com.gi.engine.util.gt;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Iterator;

import org.geotools.filter.AndImpl;
import org.geotools.filter.IsEqualsToImpl;
import org.geotools.filter.IsNotEqualToImpl;
import org.geotools.filter.LikeFilterImpl;
import org.geotools.filter.LiteralExpressionImpl;
import org.geotools.filter.NotImpl;
import org.geotools.filter.OrImpl;
import org.geotools.filter.text.ecql.ECQL;
import org.opengis.filter.Filter;
import org.opengis.filter.expression.Expression;

public class FilterUtil {

	private static char startMark = 0x02;
	private static char endMark = 0x03;

	public static Filter whereclauseToFilter(String where) {
		Filter filter = null;
		try {
			StringBuilder sb = new StringBuilder();
			for (int i = 0, count = where.length(); i < count; i++) {
				char c = where.charAt(i);
				if (c < 256) {
					sb.append(c);
				} else {
					String enc = URLEncoder.encode(String.valueOf(c), "UTF-8");
					enc = enc.replaceAll("\\%", "");
					sb.append(startMark + enc + endMark);
				}
			}
			String encode = sb.toString();
			Filter f = ECQL.toFilter(encode);
			decodeFilter(f);
			filter = f;
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return filter;
	}

	@SuppressWarnings("unchecked")
	private static void decodeFilter(Filter filter)
			throws UnsupportedEncodingException {
		if (filter instanceof OrImpl) {
			OrImpl impl = (OrImpl) filter;
			for (Iterator<Filter> itr = impl.getFilterIterator(); itr.hasNext();) {
				Filter f = itr.next();
				decodeFilter(f);
			}
		} else if (filter instanceof AndImpl) {
			AndImpl impl = (AndImpl) filter;
			for (Iterator<Filter> itr = impl.getFilterIterator(); itr.hasNext();) {
				Filter f = itr.next();
				decodeFilter(f);
			}
		} else if (filter instanceof NotImpl) {
			NotImpl impl = (NotImpl) filter;
			Filter f = impl.getFilter();
			decodeFilter(f);
		} else if (filter instanceof LikeFilterImpl) {
			LikeFilterImpl impl = (LikeFilterImpl) filter;
			String encode = impl.getLiteral();
			impl.setLiteral(decodeString(encode));
		} else if (filter instanceof IsEqualsToImpl) {
			IsEqualsToImpl impl = (IsEqualsToImpl) filter;
			decodeExpression(impl.getExpression1());
			decodeExpression(impl.getExpression2());
		} else if (filter instanceof IsNotEqualToImpl) {
			IsNotEqualToImpl impl = (IsNotEqualToImpl) filter;
			decodeExpression(impl.getExpression1());
			decodeExpression(impl.getExpression2());
		}
	}

	private static void decodeExpression(Expression exp)
			throws UnsupportedEncodingException {
		if (exp instanceof LiteralExpressionImpl) {
			LiteralExpressionImpl impl = (LiteralExpressionImpl) exp;
			String encode = String.valueOf(impl.getValue());
			impl.setValue(decodeString(encode));
		}
	}

	private static String decodeString(String encode)
			throws UnsupportedEncodingException {
		StringBuilder sb = new StringBuilder();
		int i = 0, count = encode.length();
		while (i < count) {
			int start = encode.indexOf(startMark, i);
			if (start >= 0) {
				sb.append(encode.substring(i, start));
			} else {
				sb.append(encode.substring(i));
				return sb.toString();
			}

			int end = encode.indexOf(endMark, i);
			if (end > 0) {
				i = end + 1;

				String enc = encode.substring(start + 1, end);
				StringBuilder sbEnc = new StringBuilder();
				for (int j = 0, l = enc.length(); j < l; j += 2) {
					sbEnc.append("%" + enc.charAt(j) + enc.charAt(j + 1));
				}
				String dec = URLDecoder.decode(sbEnc.toString(), "UTF-8");
				sb.append(dec);
			} else {
				sb.append(encode.substring(i + 1));
				i = count;
			}
		}
		return sb.toString();
	}

}

<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%
    Map parameterMap = request.getParameterMap();
    for (Iterator iterator = parameterMap.keySet().iterator(); iterator.hasNext();) {
        String param = (String) iterator.next();
        Object value = parameterMap.get(param);
        session.setAttribute(param, value);
        System.out.println("============= Request Map ===================");
        if (value instanceof String[]) {
            String[] strings = (String[]) value;
            for (int i = 0; i < strings.length; i++) {
                String string = strings[i];
                System.out.println("param key : " + param + " param value : " +  string);

            }

        } else {
            System.out.println("param key : " + param + " param value : " +  value);
        }

    }
    System.out.println("============== Session Map ===================");
    Enumeration attributeNames = session.getAttributeNames();
    while (attributeNames.hasMoreElements()) {
        String attribute = (String) attributeNames.nextElement();
        System.out.println("param key : " + attribute + " param value : " + session.getAttribute(attribute) );
    }


%>
<form>
    <p><label>Gadget Title : </label><input type="text" name="gadget-title" value="Gadget Generation Magnifique"/></p>
    <p><label>Gadget File Name : </label><input type="text" name="gadget-filename" value="generated-gadget"/></p>
    <p><label>Refresh Rate (in Seconds) : </label><input type="text" name="refresh-rate" value="10"/></p>
    <input type="hidden" name="page" id="page" value="04">
</form>

all: events_ts.json

schedule.xml:
	./fetch

events.xml: schedule.xml
	xalan -in $< -xsl extractEvents.xslt -out $@

events.json: events.xml
	xalan -in $< -xsl xml-to-jsonml.xsl -out $@

events_ts.json: events.json
	./timestamp
	./1337

clean:
	rm -f schedule.xml events.xml events.json events_ts.json

.PHONY: all clean

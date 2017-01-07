use strict;
use warnings;

my @lines = ();
my @json_lines = ();
my $template_file = 'generic_template.cfg';
my $card_num = 1;
my $btn_num = 1;

sub dump_usage
{
	print "[Usage] perl generate_json.pl [cgf_file]\n";
	print "--[example]--\n";
	print "perl generate_json.pl generic_template.cfg\n";
	print "perl generate_json.pl image_template.cfg\n";
	print "perl generate_json.pl text_template.cfg\n";
	print "\n";
}

sub parse_args
{
	if ($#ARGV != 0)
	{
		dump_usage();
		die "Must assign ONE template config file\n";
	}
	elsif ($ARGV[0] eq 'generic_template.cfg')
	{
		print "Parsing generic template\n";
		$template_file = 'generic_template.cfg';
	}
	elsif ($ARGV[0] eq 'image_template.cfg')
	{
		print "Parsing image template\n";
		$template_file = 'image_template.cfg';
	}
	elsif ($ARGV[0] eq 'text_template.cfg')
	{
		print "Parsing text template\n";
		$template_file = 'text_template.cfg';
	}
	else
	{
		dump_usage();
		die "Config file must be generic_template, image_template, or text_template\n";
	}
}

sub read_cfg
{
	if ($template_file eq 'generic_template.cfg' or
		$template_file eq 'image_template.cfg' or
		$template_file eq 'text_template.cfg')
	{
		open FILE, "$template_file" or die "$template_file not found\n";
		@lines = <FILE>;
		close FILE;
	}
	else
	{
		die "No such template file\n";
	}
}

sub get_generic_card_num
{
	for (@lines)
	{
		if ($_ =~ m/How many cards do you want\?/)
		{
			$card_num = $';
			$card_num =~ s/\s//g;
		}
	}
}

sub get_generic_btn_num
{
	for (@lines)
	{
		if ($_ =~ m/How many buttons do you want for a card\?/)
		{
			$btn_num = $';
			$btn_num =~ s/\s//g;
		}
	}
}

sub add_newline
{
	push @json_lines, "\n";
}

sub add_head_curly_bracket
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '{';
	add_newline();
}

sub add_recipient
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"recipient": {"id": recipient_id},';
	add_newline();
}

sub add_head_message
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"message": {';
	add_newline();
}

sub add_head_attachment
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"attachment": {';
	add_newline();
}

sub add_attachment_type
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"type": "template",';
	add_newline();
}

sub add_head_payload
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"payload": {';
	add_newline();
}

sub add_template_type
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"template_type": "generic",';
	add_newline();
}

sub add_head_elements
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"elements": [';
	add_newline();
}

sub add_card_title
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"title": "title1",';
	add_newline();  
}

sub add_card_subtitle
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"subtitle": "subtitle1",';
	add_newline();
}

sub add_card_image_url
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"image_url": \'http://certain.jpg\',';
	add_newline();
}

sub add_head_btns
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"buttons": [';
	add_newline();
}

sub add_btn_type
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"type": "web_url",';
	add_newline();
}

sub add_btn_url
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"url": "https://www.google.com",';
	add_newline();
}

sub add_btn_title
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '"title": "Open Web URL"';
	add_newline();
}

sub add_comma
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, ',';
	add_newline();
}


sub add_end_curly_bracket
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, '}';
	add_newline();
}

sub add_end_square_bracket
{
	my $indent = shift;
	for (my $i = 0; $i < $indent; $i++) { push @json_lines, "\t"; }
	push @json_lines, ']';
	add_newline();
}

sub generate_json
{
	if ($template_file eq 'generic_template.cfg')
	{
		get_generic_card_num();
		get_generic_btn_num();
		
		add_head_curly_bracket(0);            # {
			add_recipient(1);                 # "recipient": {"id": recipient_id},
			add_head_message(1);              # "message": {
				add_head_attachment(2);       # "attachment": {
					add_attachment_type(3);   # "type": "template",
					add_head_payload(3);      # "payload": {
						add_template_type(4); # "template_type": "generic",
						add_head_elements(4); # "elements": [
						for (my $i = 0; $i < $card_num; $i++)
						{
							add_head_curly_bracket(5); # {
								add_card_title(6);     #  "title": "title1",
								add_card_subtitle(6);  #  "subtitle": "subtitle1",
								add_card_image_url(6); #  "image_url": 'http://certain.jpg',
								add_head_btns(6);      #  "buttons": [
								for (my $j = 0; $j < $btn_num; $j++)
								{
									add_head_curly_bracket(7); # {
									add_btn_type(7);   # "type": "web_url",
									add_btn_url(7);    # "url": "https://www.google.com",
									add_btn_title(7);  # "title": "Open Web URL"
									add_end_curly_bracket(7); # }
									add_comma(7) if ($j < $btn_num - 1); # ,
								}
								add_end_square_bracket(6); # ]
							add_end_curly_bracket(5); # }
							add_comma(5) if ($i < $card_num - 1) #,
						}
						add_end_square_bracket(4); # ]
					add_end_curly_bracket(3);      # }
				add_end_curly_bracket(2);          # }
			add_end_curly_bracket(1);              # }
		add_end_curly_bracket(0);                  # }
	}
	elsif ($template_file eq 'image_template.cfg')
	{

	}
	elsif ($template_file eq 'text_template.cfg')
	{

	}
	else
	{
		die "no such template file\n";
	}
}

sub dump_to_file
{
	open FILE, "> dump_json.txt" or die "Cannot open dump file";
	for (@json_lines){
		print FILE $_;
	}
	close FILE;
}

sub main
{
	parse_args();
	read_cfg();
	generate_json();
	dump_to_file();
}

main();
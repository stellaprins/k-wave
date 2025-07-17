function runUnitTests_show_results(test_struct)
%RUNUNITTESTS_SHOW_RESULTS Display MATLAB unit test results in a formatted summary.
%
% DESCRIPTION:
%     runUnitTests_show_results displays the results from the provided test_struct
%     in a formatted summary, including test details, individual test outcomes,
%     and a summary of passed and failed tests.
%

% =========================================================================
% DISPLAY SUMMARY
% =========================================================================

info = test_struct.info;
results = test_struct.results;

% display test header
disp('   ');
disp('-------------------------------------------------------------------------------------');
disp('            _      __        __                _____         _            ');
disp('           | | __  \ \      / /_ ___   _____  |_   _|__  ___| |_ ___ _ __ ');
disp('           | |/ /___\ \ /\ / / _` \ \ / / _ \   | |/ _ \/ __| __/ _ \ ''__|');
disp('           |   <_____\ V  V / (_| |\ V /  __/   | |  __/\__ \ ||  __/ |   ');
disp('           |_|\_\     \_/\_/ \__,_| \_/ \___|   |_|\___||___/\__\___|_|   ');
disp('  ');                                                                
disp('-------------------------------------------------------------------------------------');
disp('  ');
disp(['DATE:                     ' info.date]);
disp(['HOST NAME:                ' info.computer_name]);
disp(['USER NAME:                ' info.user_name]);
disp(['O/S TYPE:                 ' info.operating_system_type]);
disp(['O/S:                      ' info.operating_system]);
disp(['MATLAB VERSION:           ' info.matlab_version]);
disp(['TESTED K-WAVE VERSION:    ' info.kwave_version]);
disp(['TESTS COMPLETED IN:       ' info.completion_time]);
disp('  ');

% display individual test results
disp('UNIT TEST RESULTS:');

for i = 1:length(results)
    
    % trim the filename
    fn = results(i).test;
    fn = [fn(1:end - 2), ':'];
    
    % add some spaces to align results
    fn = sprintf('%-70s', fn);
    
    % append the test result
    if results(i).pass
        disp(['  ' fn 'passed']);
    else
        disp(['  ' fn 'failed']);
    end
    
end

% display test summary
disp('  ');
disp('UNIT TEST SUMMARY:');
num_passed = sum([results.pass]);
num_failed = numel(results) - num_passed;
disp(['✅ Number of tests passed: ' num2str(num_passed)]);
disp(['❌ Number of tests failed: ' num2str(num_failed)]);
disp('  ');


% Write failed tests summary as Markdown to a file
failed_idx = find(~[results.pass]);
if ~isempty(failed_idx)
    mdfile = 'failed_tests_summary.md'; % Output filename
    fid = fopen(mdfile, 'w');
    fprintf(fid, '## Failed Tests\n');
    fprintf(fid, '| Test Name | Info |\n');
    fprintf(fid, '|-----------|------|\n');
    for i = failed_idx
        fn = results(i).test;
        fn = strrep(fn(1:end - 2), '|', '\|'); % escape pipes in test name
        if ~isempty(results(i).test_info)
            info_str = ['```', newline, results(i).test_info, newline, '```'];
        else
            info_str = '';
        end
        info_str = strrep(info_str, '|', '\|'); % escape pipes in info
        fprintf(fid, '| %s | %s |\n', fn, info_str);
    end
    fclose(fid);
    disp(['Failed tests summary written to ' mdfile]);
end